#
# Remove Attach filter
#
# Copyright (C) All right reserved by TADA Tadashi <sho@spc.gr.jp> 2001
# You can redistribute it and/or modify it under the same term as GPL2.
#
class RemoveAttachFilter < Filter
	def RemoveAttachFilter::description
		[
			'RemoveAttachFilter',
			'添付ファイル削除',
			'添付ファイルを削除して、最初のテキスト部分だけにします。最初のフィルタに指定すると良いでしょう。'
		]
	end

	def header_filter( header )
		@boundary = nil
		header.to_a.collect do |item|
			if @boundary == :continue then
 				item.split( ';' ).each do |c|
 					if /^boundary="(.*?)"/i =~ c.strip then @boundary = "--#$1\n" end
 				end
 				next
			end
			if /^Content-Type:\s+(.*)$/i =~ item then
				content_type = $1
				if /multipart\/mixed/i =~ content_type then
					content_type.split( ';' ).each do |c|
						if /^boundary="(.*?)"/i =~ c.strip then @boundary = "--#$1\n" end
					end
					@boundary = :continue unless @boundary
				end
				%Q|Content-Type: text/plain; charset="iso-2022-jp"\n|
			else
				item
			end
		end.join
	end

	def body_filter( body )
		if @boundary then
			body.split( @boundary ).each_with_index do |part,i|
				h, b = part.split( "\n\n", 2 )
				next if not b
				return b if /^Content-Type:\s+text\//i =~ h
			end
			"no text part\n"
		else
			body
		end
	end
end

