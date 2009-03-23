#
# ISO-2022-JP compact filter $Revision: 1.5 $
# by MoonWolf
#

module ISO_2022_JP
	MAP='!!!*!I!t!p!s!u!G!J!K!v!\!$!]!%!?#0#1#2#3#4#5#6#7#8#9!\'!(!c!a!d!)!w#A#B#C#D#E#F#G#H#I#J#K#L#M#N#O#P#Q#R#S#T#U#V#W#X#Y#Z!N!o!O!0!2!.#a#b#c#d#e#f#g#h#i#j#k#l#m#n#o#p#q#r#s#t#u#v#w#x#y#z!P!C!Q!1'
	def min( kcode_string )
		s = NKF::nkf( '-E -Z1 -m0', kcode_string ).gsub( /\33\(B([\x20-\x7e]{1,5})\33\$B/n ) {
			word = ''
			$1.each_byte do |b|
				word << MAP[b*2-64,2]
			end
			word
		}
		NKF::nkf( '-e -m0', s )
	end
	module_function :min
end

class JisCompactFilter < Filter
	def JisCompactFilter::description
		[
			'JisCompactFilter',
			'全角←→半角で小さくする',
			'iso-2022-jpでバイト数が少なくなるように英数字・記号を全角または半角にします。'
		]
	end

	def body_filter( body )
		ISO_2022_JP.min( body )
	end
end

