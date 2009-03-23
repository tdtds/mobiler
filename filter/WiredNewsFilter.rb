#
# WIRED NEWS filter $Revision: 1.6 $
#
# Copyright (C) All right reserved by TADA Tadashi <sho@spc.gr.jp> 2001
# You can redistribute it and/or modify it under the same term as GPL2.
#
class WiredNewsFilter < Filter
	def WiredNewsFilter::description
		[
			'WiredNewsFilter',
			'WIRED NEWS',
			'WIRED NEWSメールをコンパクトにするフィルタです。広告およびお知らせの削除を行ないます。'
		]
	end

	def body_filter( body )
		body = NKF::nkf( '-XdEeZ -m0', body )
		body.gsub!( '　', ' ' )
		body.gsub!( ' +■$', '' )
		body.gsub!( '////', '' )
		body.gsub!( /[━┃┏┓┗┛]+/, '' )
		body.gsub!( / {2,}/, ' ' )
		body.gsub!( /^ +/, '' )
		body.gsub!( /^_{4,}/, '' )
		body.gsub!( /(-|=){2,}/, '\1\1' )
		body.gsub!( /^[0-9]+ +■/, '■' )
		#body.gsub!( %r{<?\s+(http|https|ftp)://[\(\)%#!/0-9a-zA-Z_$@.&+-,'"*=;?:~-]+\s+>?}, '(URL)' )
		body.gsub!( /W I R E D N E W S/, '' )
		body.gsub!( /H O T W I R E D J A P A N/, '' )
		body.gsub!( /^WIRED NEWS.*$/, '' )
		body.gsub!( /^P O S T.*$/, '' )
		body.gsub!( /^.*C o n t e n t s.*$/, '' )
		body.gsub!( /T O P I C S$/, '◆TOPICS' )
		body.gsub!( /S E E D$/, '◆SEED' )
		body.gsub!( /C O L U M N$/, '◆COLUMN' )
		body.gsub!( /I N T E R V I E W$/, '◆INTERVIEW' )
		body.gsub!( /^Wam-Online.*/, '' )
		body.gsub!( /^\[ PR \]$/, '==PR==' )
		body.gsub!( /^\s*★今週のスペシャル★\s*$/, '==PR==' )
		body.gsub!( /^\s*\[ Advertisement \]\s*$/, '==PR==' )
		body.gsub!( /^\[ [^()]+? \]$/, '==PR==' )
		body.gsub!( /^\[[^()]+?\]$/, '' )
		body.gsub!( /\(IE\)/i, '' )
		body.gsub!( /Internet\s*Explorer/i, 'IE' )
		body.gsub!( /インターネット・*エクスプローラー*/i, 'IE' )
		body.gsub!( /Internet/i, 'INET' )
		body.gsub!( /インターネット/, 'INET' )
		body.gsub!( /プロバイダー/, 'ISP' )
		body.gsub!( /Sun Microsystems/, 'Sun' )
		body.gsub!( /データベース/, 'DB' )
		body.gsub!( /アプリケーション/, 'アプリ' )
		body.gsub!( /ニフティ株式会社/, 'NIFTY' )

		pr = false
		footer = false
		genre = nil
		prev = nil
		body.to_a.collect { |item|
			if !pr and /^==(AD|PR)==$/ =~ item then
				pr = true
				nil
			elsif pr and /^==(AD|PR)==$/ =~ item
				pr = false
				nil
			elsif /I N F O R M A T I O N/ =~ item
				footer = true
				nil
			elsif /^【ご意見、お問合せ】/ =~ item
				footer = true
				nil
			elsif /★ASCII24ホームページについて/ =~ item
				footer = true
				nil
			elsif /★Wam-Onlineについてのお問い合わせ/ =~ item
				footer = true
				nil
			elsif pr or footer
				nil
			elsif /^$/ =~ item
				nil
			else
				if prev == item then nil else prev = item end
			end
		}.join
	end
end

