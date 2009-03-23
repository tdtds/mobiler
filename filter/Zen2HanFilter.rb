#
# Zen-kaku to Han-kaku filter
#
# Copyright (C) All right reserved by TADA Tadashi <sho@spc.gr.jp> 2001
# You can redistribute it and/or modify it under the same term as GPL2.
#
class Zen2HanFilter < Filter
	def Zen2HanFilter::description
		[
			'Zen2HanFilter',
			'���Ѣ�Ⱦ��',
			'���Ѥαѿ����������Ⱦ�Ѥˤ��ޤ������ʤ�Ⱦ�ѤˤϤ��ޤ���'
		]
	end

	def body_filter( body )
		NKF::nkf( '-XdEeZ -m0', body ).gsub( '��', ' ' )
	end
end

