#
# Basic Header Filter
#
# Copyright (C) All right reserved by TADA Tadashi <sho@spc.gr.jp> 2001
# You can redistribute it and/or modify it under the same term as GPL2.
#
class BasicHeaderFilter < Filter
	def BasicHeaderFilter::description
		[
			'BasicHeaderFilter',
			'シンプルヘッダフィルタ',
			'余分なヘッダ情報(Received,X-*,Resent-*)を削除します。BasicFilterのヘッダのみ版です。'
		]
	end

	def header_filter( header )
		delete = false
		header.to_a.collect { |item|
			if /^(Received|Resent-.*?|X-.*?):/i =~ item then
				delete = true
				nil
			elsif /^>?From /i =~ item then
				delete = true
				nil
			elsif /^\s+/ =~ item and delete
				nil
			else
				delete = false
				item
			end
		}.join
	end
end

