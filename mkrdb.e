


-- displays a file like od under linux
class MKRDB

insert
	ARGUMENTS

creation {}
	make

feature {}
	bytes_per_line: INTEGER is 16

feature {}
	is_printable (b: INTEGER): BOOLEAN is
		do
			Result := b.to_character >= ' ' and b.to_character <= '{'
		end

feature {}
	put_character (b: INTEGER) is
		do
			if is_printable(b) then
				io.put_character(b.to_character)
			else
				io.put_character('.')
			end
		end

feature {}
	make is
		local
			f: BINARY_FILE_READ; b: INTEGER; address: INTEGER; line: ARRAY[INTEGER]; pos_in_line: INTEGER; i: INTEGER
		do
			if argument(1).is_equal("-h") then
				io.put_string("Usage: mkrdb <file>%N")
				io.put_string("Author: Thomas Preymesser (thopre@gmail.com)%N")
				die_with_code(0)
			end
			pos_in_line := 1 -- zaehlt von 1..bpl
			create line.make(1, bytes_per_line)
			from
				create f.connect_to(argument(1))
				f.read_byte
			until
				f.end_of_input
			loop
				b := f.last_byte
				line.put(b, pos_in_line)
				if pos_in_line >= bytes_per_line then
					pos_in_line := 1
				else
					pos_in_line := pos_in_line + 1
				end
				if address \\ bytes_per_line = 0 then
					io.put_string(address.to_hexadecimal)
					io.put_string(" ")
				end
				io.put_string(b.to_character.to_hexadecimal)
				io.put_string(" ")
				if (address + 1) \\ bytes_per_line = 0 then
					from
						i := 1
					until
						i > bytes_per_line
					loop
						put_character(line.item(i))
						i := i + 1
					end
					io.put_new_line
				end
				address := address + 1
				f.read_byte
			end
			f.disconnect
			if pos_in_line /= 1 then
				-- noch restliche Characters
				-- auszugeben
				from
					i := 1
				until
					i >= (bytes_per_line - pos_in_line + 1) * 3 + 1
				loop
					io.put_character(' ')
					i := i + 1
				end
				from
					i := 1
				until
					i >= pos_in_line
				loop
					put_character(line.item(i))
					i := i + 1
				end
			end
			io.put_new_line
		end

end -- class MKRDB
About
Subscribe
