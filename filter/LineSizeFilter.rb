#
# Line Size Filter
#
# Copyright (C) All right reserved by Akira Kato <akira@spc.gr.jp> 2001
# You can redistribute it and/or modify it under the same term as GPL2.
#
class LineSizeFilter < Filter
	def LineSizeFilter::description
		[
			'LineSizeFilter',
			'本文を指定サイズで改行する',
			'指定した文字数で改行コードを挿入し、本文の行の長さを調整します。携帯電話の文字メールなど文字数制限がある場合にも有効です。'
		]
	end

  def initialize( *opt )
		super
		raise FilterError.new( "LineSizeFilter: Need size." ) if @options.size != 1
		@size = @options[0]
	end

	def body_filter( body )
		newbody=''
		limit	=	Integer(@size)
		body.each_line do |line| 
			newline=''
			while(line.size > limit) do
				a=cut(line,limit/2)
				line=line[a.size..-1]
				newline+="#{a}\n"
			end
			newline+=line
			newbody+=newline
		end
		"#{newbody}"
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

