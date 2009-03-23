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
			'�����֤�û��',
			'Ϣ³������-�ס�=�ס�+�ס�*�ס� (����)�ס֡��פ򡢤ҤȤĤ�û�̤��ޤ����ѥ�᥿�ˤϲ��󷫤��֤�����û�̤��뤫����ꤷ�ޤ�(�ǥե���Ȥ�4��)��'
		]
	end

	def initialize( *opt )
		super
		@repeat = @options[0].to_i
		@repeat = 4 if @repeat < 2
	end

	def body_filter( body )
		body.gsub( /(-|=|\+|\*| |��){#{@repeat},}/, '\1' )
	end
end

