class Api::V1::ListingsController < ApplicationController

	def get_listing
		# receive props from front end get request
		# send EXCON get request to zillow, and process data
		# send back to front end
		url_address = split_address(listing_params["address"])	
		response = Excon.get("http://www.zillow.com/webservice/GetDeepSearchResults.htm?zws-id=X1-ZWz1fzorn263gr_9abc1&address=#{url_address[0]}&citystatezip=#{url_address[1]}%2C+#{url_address[2]}&rentzestimate=true")
		response_hash = Hash.from_xml(response.body)
		z_property_id = response_hash["searchresults"]["response"]["results"]["result"]["zpid"]
		final_result = get_sort_details(z_property_id, response_hash)
		render json: final_result
	end

	def get_sort_details(z_property_id, original_results)
		rent_estimate = nil
		comps = Excon.get("http://www.zillow.com/webservice/GetDeepComps.htm?zws-id=X1-ZWz1fzorn263gr_9abc1&zpid=#{z_property_id}&count=5&rentzestimate=true")
		comps_hash = Hash.from_xml(comps.body)
		if original_results["searchresults"]["response"]["results"]["result"]["rentzestimate"] == nil
			count = 0
			sum = 0		
			comps_hash["comps"]["response"]["properties"]["comparables"]["comp"].map do |comp|
				if comp["rentzestimate"] != nil
					sum += comp["rentzestimate"]["amount"].to_i
					count += 1
				end
			end
			rent_estimate = sum / count
		else
			rent_estimate = original_results["searchresults"]["response"]["results"]["result"]["rentzestimate"]["amount"].to_i		
		end	
			if comps_hash["comps"]["message"]["code"] == "504"
				actual_comps = comps_hash["comps"]["message"]["text"]
			else
				actual_comps = comps_hash["comps"]["response"]["properties"]["comparables"]["comp"]	
			end
		return [original_results["searchresults"]["response"]["results"]["result"], actual_comps, rent_estimate]
	end


	def split_address(address)
		split_address = address.split(", ")
		street_address = split_address[0].gsub(/ /, '+')
		city = split_address[1].gsub(/ /, '+')
		state = split_address[2].slice(0, 2)
		return [street_address, city, state]
	end

	private 

	def listing_params
		params.permit(:address)
	end

end