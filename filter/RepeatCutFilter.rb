#
# RepeatCutFilter
#
# Copyright (C) All right reserved by TADA Tadashi <sho@spc.gr.jp> 2001
# You can redistribute it and/or modify it under the same term as GPL2.
#
class RepeatCutFilter < Filter
	def RepeatCutFilter::description
		[
			'RepeatCutFilter',
			'繰り返し短縮',
			'連続した「-」「=」「+」「*」「 (空白)」「―」を、ひとつに短縮します。パラメタには何回繰り返したら短縮するかを指定します(デフォルトは4回)。'
		]
	end

	def initialize( *opt )
		super
		@repeat = @options[0].to_i
		@repeat = 4 if @repeat < 2
	end

	def body_filter( body )
		body.gsub( /(-|=|\+|\*| |―){#{@repeat},}/, '\1' )
	end
end

