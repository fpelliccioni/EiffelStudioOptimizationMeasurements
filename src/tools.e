note
	description: "Summary description for {TOOLS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TOOLS

create
	make

feature
	rnd: RANDOM


	make
		do
			initialize_random_generator
		end

	nanoseconds_since_epoch (): INTEGER_64
        	-- Returns a 64-bit signed integer representing the number of nanoseconds elapsed between Now and the clock's Unix epoch.
        external
            "C++ inline use <chrono>"
        alias
            "{
				return std::chrono::duration_cast<std::chrono::nanoseconds>(
						std::chrono::high_resolution_clock::now().time_since_epoch()
						).count();
            }"
        end

	initialize_random_generator
		local
			l_time: TIME
			l_seed: INTEGER
		do
			create l_time.make_now
     		l_seed := l_time.hour
      		l_seed := l_seed * 60 + l_time.minute
			l_seed := l_seed * 60 + l_time.second
      		l_seed := l_seed * 1000 + l_time.milli_second
      		create rnd.set_seed (l_seed)
		end

	create_random_array(size : INTEGER) : ARRAY[INTEGER]
		local
			i : INTEGER
		do
			create Result.make_filled (0, 1, size)

			from
				i := 1
			until
				i >  Result.count
			loop
				 Result.enter (random_integer // 256 , i)
				i := i + 1
			end
		end

	random_integer : INTEGER
		do
			rnd.forth
            Result := rnd.item
 		end
end
