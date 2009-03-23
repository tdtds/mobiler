#
# Basic Body Filter
#
# Copyright (C) All right reserved by TADA Tadashi <sho@spc.gr.jp> 2001
# You can redistribute it and/or modify it under the same term as GPL2.
#
class BasicBodyFilter < Filter
	def BasicBodyFilter::description
		[
			'BasicBodyFilter',
			'シンプルボディフィルタ',
			'本文中の空改行と行頭/行末の空白を削除します。BasicFilterの本文のみ版です。'
		]
	end

	def body_filter( body )
		body.to_a.collect { |item|
			if /^$/ =~ item then
				nil
			elsif /^[ 　]*(.*?)[ 　]*$/ =~ item
				"#$1\n"
			else
				item
			end
		}.join
	end
end

