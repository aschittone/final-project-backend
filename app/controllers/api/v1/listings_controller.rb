class Api::V1::ListingsController < ApplicationController

	def get_listing
		url_address = split_address(listing_params["address"])	
		response = Excon.get("http://www.zillow.com/webservice/GetDeepSearchResults.htm?zws-id=X1-ZWz1fzorn263gr_9abc1&address=#{url_address[0]}&citystatezip=#{url_address[1]}%2C+#{url_address[2]}&rentzestimate=true")
		response_hash = Hash.from_xml(response.body)
		if response_hash["searchresults"]["response"]["results"]["result"].class == Array && response_hash["searchresults"]["response"]["results"]["result"][0]["address"]["street"] == response_hash["searchresults"]["response"]["results"]["result"][1]["address"]["street"]
			z_property_id = response_hash["searchresults"]["response"]["results"]["result"][0]["zpid"]
			result = get_sort_details(z_property_id, response_hash)
			final_result = get_details(result)
			render json: final_result
		elsif response_hash["searchresults"]["response"]["results"]["result"].class == Array
			result = []
			response_hash["searchresults"]["response"]["results"]["result"].map do |property|
				result << property["address"]["street"] + ", " + property["address"]["city"] + ", " + property["address"]["state"]
			end
			render json: result
		else
			street = response_hash["searchresults"]["response"]["results"]["result"]["address"]["street"]
			city = response_hash["searchresults"]["response"]["results"]["result"]["address"]["city"]
			state = response_hash["searchresults"]["response"]["results"]["result"]["address"]["state"]
			if url_address.length < 4 && city.gsub(/ /, '+') != url_address[1] 
				result = []
				result << "#{street}, #{city}, #{state}"
				render json: result
			else
	
				z_property_id = response_hash["searchresults"]["response"]["results"]["result"]["zpid"]
				result = get_sort_details(z_property_id, response_hash)
				final_result = get_details(result)
				render json: final_result
			end
		end
	end

	def get_sort_details(z_property_id, original_results)
		rent_estimate = nil
		comps = Excon.get("http://www.zillow.com/webservice/GetDeepComps.htm?zws-id=X1-ZWz1fzorn263gr_9abc1&zpid=#{z_property_id}&count=4&rentzestimate=true")
		comps_hash = Hash.from_xml(comps.body)
		if original_results["searchresults"]["response"]["results"]["result"].class == Hash && original_results["searchresults"]["response"]["results"]["result"]["rentzestimate"] == nil
			count = 0
			sum = 0		
			comps_hash["comps"]["response"]["properties"]["comparables"]["comp"].map do |comp|
				if comp["rentzestimate"] != nil
					sum += comp["rentzestimate"]["amount"].to_i
					count += 1
				end
			end
			rent_estimate = sum / count
		elsif original_results["searchresults"]["response"]["results"]["result"].class == Array 
			rent_estimate = original_results["searchresults"]["response"]["results"]["result"][0]["rentzestimate"]["amount"].to_i	
		else 	
			rent_estimate = original_results["searchresults"]["response"]["results"]["result"]["rentzestimate"]["amount"].to_i				
		end			
			if comps_hash["comps"]["message"]["code"] == "504" || comps_hash["comps"]["message"]["code"] == "503"
				actual_comps = comps_hash["comps"]["message"]["text"]
			else
				if comps_hash["comps"]["response"]["properties"]["comparables"]["comp"].class == Hash
					actual_comps = []
					actual_comps.push(comps_hash["comps"]["response"]["properties"]["comparables"]["comp"])
				else 
					actual_comps = comps_hash["comps"]["response"]["properties"]["comparables"]["comp"]
				end
			end
			if original_results["searchresults"]["response"]["results"]["result"].class == Array
				return [original_results["searchresults"]["response"]["results"]["result"][0], actual_comps, rent_estimate]
			else 
				return [original_results["searchresults"]["response"]["results"]["result"], actual_comps, rent_estimate]
			end
	end

	def get_details(results)
		# another fetch to get property details
		full_street = results[0]["address"]["street"]
		city = results[0]["address"]["city"]
		state = results[0]["address"]["state"]
		data = Excon.get("https://search.onboard-apis.com/propertyapi/v1.0.0/allevents/detail?address1=#{full_street}&address2=#{city} #{state}", headers: {Accept: 'application/json',APIKey: 'f137e17eb6b1e71808a39da5419874bb'})
		if JSON.parse(data[:body])["status"]["msg"] == "Geocoder Results Address Not Identified." || JSON.parse(data[:body])["status"]["msg"] == "SuccessWithoutResult"
			return results << "tax data not available"
		else			
			return results << data
		end
	end


	def split_address(address)
		split_address = address.split(", ")
		street_address = split_address[0].gsub(/ /, '+')
		city = split_address[1].gsub(/ /, '+')
		state = split_address[2].slice(0, 2)
		if split_address[split_address.length - 1].include?("second")
			return [street_address, city, state, "second"]
		else
			return [street_address, city, state]
		end
	end

	private 

	def listing_params
		params.permit(:address)
	end

end

