#!/usr/bin/env ruby

require 'rex/post/process'
require 'rex/post/meterpreter/packet'
require 'rex/post/meterpreter/client'
require 'rex/post/meterpreter/extensions/stdapi/constants'
require 'rex/post/meterpreter/extensions/stdapi/stdapi'

module Rex
module Post
module Meterpreter
module Extensions
module Stdapi
module Sys

###
#
# This class provides access to remote system configuration and information.
#
###
class Config

	def initialize(client)
		self.client = client
	end

	#
	# Returns the username that the remote side is running as.
	#
	def getuid
		request  = Packet.create_request('stdapi_sys_config_getuid')
		response = client.send_request(request)
		return Rex::Text.unicode_filter_encode( response.get_tlv_value(TLV_TYPE_USER_NAME) )
	end

	#
	# Returns a hash of information about the remote computer.
	#
	def sysinfo
		request  = Packet.create_request('stdapi_sys_config_sysinfo')
		response = client.send_request(request)

		{
			'Computer'        => response.get_tlv_value(TLV_TYPE_COMPUTER_NAME),
			'OS'              => response.get_tlv_value(TLV_TYPE_OS_NAME),
			'Architecture'    => response.get_tlv_value(TLV_TYPE_ARCHITECTURE),
			'System Language' => response.get_tlv_value(TLV_TYPE_LANG_SYSTEM),
		}
	end

	#
	# Calls RevertToSelf on the remote machine.
	#
	def revert_to_self
		client.send_request(Packet.create_request('stdapi_sys_config_rev2self'))
	end

	#
	# Steals the primary token from a target process
	#
	def steal_token(pid)
		req = Packet.create_request('stdapi_sys_config_steal_token')
		req.add_tlv(TLV_TYPE_PID, pid.to_i)
		res = client.send_request(req)
		return Rex::Text.unicode_filter_encode( res.get_tlv_value(TLV_TYPE_USER_NAME) )
	end

	#
	# Drops any assumed token
	#
	def drop_token
		req = Packet.create_request('stdapi_sys_config_drop_token')
		res = client.send_request(req)
		return Rex::Text.unicode_filter_encode( res.get_tlv_value(TLV_TYPE_USER_NAME) )
	end

	#
	# Enables all possible privileges
	#
	def getprivs
		req = Packet.create_request('stdapi_sys_config_getprivs')
		ret = []
		res = client.send_request(req)
		res.each(TLV_TYPE_PRIVILEGE) do |p|
			ret << p.value
		end
		return ret
	end

protected

	attr_accessor :client

end

end; end; end; end; end; end

