#
# きゃらメール Filter
#
# Copyright (C) All right reserved by TADA Tadashi <sho@spc.gr.jp> 2001
# You can redistribute it and/or modify it under the same term as GPL2.
#
class CharMailFilter < Filter
	def CharMailFilter::description
		[
			'CharMailFilter',
			'旧式きゃらメール',
			'NTT DoCoMoのPHSで使えるチープなメールサービス「きゃらメール」に転送するためのフィルタ。最近のきゃらメールは漢字も受け取れるようなのでこのフィルタは不要でしょう。これは70文字制限で、ひらがな・カタカナ・英数字と一部の記号しか使えない古いきゃらメール対応端末用です。先にBasicFilterを通してください。'
		]
	end

	def header_filter( header )
		@from = ''
		if /^From:\s+.*<+(.*)@.*>/ =~ header or /^From:\s+(.*?)@/ =~ header then
			@from = $1
		end
		header
	end

	def body_filter( body )
		body = NKF::nkf( '-EeZ1', body ).gsub( /[.,。、．，]/, ' ' )
		body.gsub!( /[^あ-んア-ンA-z0-9?!#&()\\\[\]{}<>\/_ -]/, '_' )
		body.gsub!( /([がぎぐげござじずぜぞだぢずでどばびぶべぼ])/, '\1゛' )
		body.gsub!( /([ぱぴぷぺぽ])/, '\1゜' )
		body.gsub!( /([ガギグゲゴザジズゼゾダヂヅデドバビブベボ])/, '\1゛' )
		body.gsub!( /([パピプペポ])/, '\1゜' )
		body.gsub!( /[\n\r]/, ' ' )
		body = cut( body, 70 - @from.length - 3 )
		body.gsub!( /[゛゜]/, '' )
		"#{@from} #{body}\n"
	end

private
	def cut( str, limit )
		tmp = nil
		result = ''
		count = 0
		str.each_byte do |c|
			s = ''
			if tmp then
				s << tmp << c
				count += 1
				tmp = nil
			elsif c > 0x80
				tmp = c
			else
				s << c
				count += 1
			end
			break if count > limit
			result << s
		end
		result
	end
end

