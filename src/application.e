note
	description : "EiffelStudioOptimizationMeasurements application root class"
	date        : "$Date$"
	revision    : "$Revision$"

class
	APPLICATION

inherit
	ARGUMENTS

create
	make

feature

	tools : TOOLS


	---------------------------------------------------------------
	-- Sum algorithms
	---------------------------------------------------------------

	sum_original(data : ARRAY[INTEGER]) : INTEGER_64
		local
			i: INTEGER
		do
			from
				i := 1
			until
				i > data.count
			loop
				Result := Result + data[i]  --data.item(i)
				i := i + 1
			end
		end

	sum_original_32(data : ARRAY[INTEGER]) : INTEGER_32
		local
			i: INTEGER
		do
			from
				i := 1
			until
				i > data.count
			loop
				Result := Result + data[i]  --data.item(i)
				i := i + 1
			end
		end

	sum_original_across(data : ARRAY[INTEGER]) : INTEGER_64
		do
			across
				data as ic
			loop
				Result := Result + ic.item
			end
		end

	sum_original_across_32(data : ARRAY[INTEGER]) : INTEGER_32
		do
			across
				data as ic
			loop
				Result := Result + ic.item
			end
		end

	sum_local_count(data : ARRAY[INTEGER]) : INTEGER_64
		local
			i: INTEGER
			n: INTEGER
		do
			from
				i := 1
				n := data.count
			until
				i > n
			loop
				Result := Result + data[i]
				i := i + 1
			end
		end

	sum_type_mismatch(data : ARRAY[INTEGER]) : INTEGER_64
		local
			i: INTEGER
			x: INTEGER
		do
			from
				i := 1
			until
				i > data.count
			loop
				x := data[i]
            	Result := Result + x
				i := i + 1
			end
		end

	sum_type_mismatch_64(data : ARRAY[INTEGER]) : INTEGER_64
		local
			i: INTEGER
			x: INTEGER_64
		do
			from
				i := 1
			until
				i > data.count
			loop
				x := data[i]
            	Result := Result + x
				i := i + 1
			end
		end

	sum_local_count_type_mismatch(data : ARRAY[INTEGER]) : INTEGER_64
		local
			i: INTEGER
			n: INTEGER
			x: INTEGER
		do
			from
				i := 1
				n := data.count
			until
				i > n
			loop
				x := data[i]
            	Result := Result + x
				i := i + 1
			end
		end

	sum_local_count_type_mismatch_64(data : ARRAY[INTEGER]) : INTEGER_64
		local
			i: INTEGER
			n: INTEGER
			x: INTEGER_64
		do
			from
				i := 1
				n := data.count
			until
				i > n
			loop
				x := data[i]
            	Result := Result + x
				i := i + 1
			end
		end


   sum_just_special(data : ARRAY[INTEGER]) : INTEGER_64
      local
         i: INTEGER
         a: SPECIAL [INTEGER]
      do
         from
            i := 0
            a := data.area
         until
            i >= data.count
         loop
            Result := Result + a[i]
            i := i + 1
         end
      end

   sum_alex(data : ARRAY[INTEGER]) : INTEGER_64
      local
         i: INTEGER
         a: SPECIAL [INTEGER]
         x: INTEGER
         n: INTEGER
      do
         from
            i := 0
            a := data.area
            n := data.count
         until
            i >= n
         loop
            x := a [i]
            Result := Result + x
            i := i + 1
         end
      end

   sum_alex_type_mismatch_64(data : ARRAY[INTEGER]) : INTEGER_64
      local
         i: INTEGER
         a: SPECIAL [INTEGER]
         x: INTEGER_64
         n: INTEGER
      do
         from
            i := 0
            a := data.area
            n := data.count
         until
            i >= n
         loop
            x := a [i]
            Result := Result + x
            i := i + 1
         end
      end

	---------------------------------------------------------------
	-- Mearurement tools
	---------------------------------------------------------------

  	measure(data : ARRAY[INTEGER]; f: FUNCTION[ANY, TUPLE[ARRAY[INTEGER]], INTEGER_64]; iterations_par : INTEGER) : DOUBLE
		local
			measurements : ARRAYED_LIST[DOUBLE]
			iterations : INTEGER
			res : INTEGER_64
			s_time: INTEGER_64
			e_time: INTEGER_64
			sorter: QUICK_SORTER[DOUBLE]
			i : INTEGER_32
			runs : INTEGER_32
		do
			create measurements.make(iterations_par)
			Result := 0

			from
				iterations := iterations_par
			until
				iterations = 0
			loop

				from
					s_time := tools.nanoseconds_since_epoch
					e_time := s_time
					runs := 0
				until
					e_time - s_time >= 200000000 --(200 milliseconds)
				loop
--					res := f.item([data, fro, to])   -- Type System violation: Error not catched by the compiler.
					res := f.item([data])
					e_time := tools.nanoseconds_since_epoch
					runs := runs + 1
				end

--				e_time := nanoseconds_since_epoch
				measurements.put_front ((e_time - s_time)/runs)

				iterations := iterations - 1
			end

			create sorter.make (create {COMPARABLE_COMPARATOR [DOUBLE]})
			sorter.sort(measurements)

			from
				i := 0
			until
				i > measurements.count * 0.8
			loop

				if i > measurements.count * 0.2 then
					Result := Result + measurements.at (i)
				end
				i := i + 1
			end



		end

  	measure_32(data : ARRAY[INTEGER]; f: FUNCTION[ANY, TUPLE[ARRAY[INTEGER]], INTEGER_32]; iterations_par : INTEGER) : DOUBLE
		local
			measurements : ARRAYED_LIST[DOUBLE]
			iterations : INTEGER
			res : INTEGER_32
			s_time: INTEGER_64
			e_time: INTEGER_64
			sorter: QUICK_SORTER[DOUBLE]
			i : INTEGER_32
			runs : INTEGER_32
		do
			create measurements.make(iterations_par)
			Result := 0

			from
				iterations := iterations_par
			until
				iterations = 0
			loop

				from
					s_time := tools.nanoseconds_since_epoch
					e_time := s_time
					runs := 0
				until
					e_time - s_time >= 200000000 --(200 milliseconds)
				loop
--					res := f.item([data, fro, to])   -- Type System violation: Error not catched by the compiler.
					res := f.item([data])
					e_time := tools.nanoseconds_since_epoch
					runs := runs + 1
				end

--				e_time := nanoseconds_since_epoch
				measurements.put_front ((e_time - s_time)/runs)

				iterations := iterations - 1
			end

			create sorter.make (create {COMPARABLE_COMPARATOR [DOUBLE]})
			sorter.sort(measurements)

			from
				i := 0
			until
				i > measurements.count * 0.8
			loop

				if i > measurements.count * 0.2 then
					Result := Result + measurements.at (i)
				end
				i := i + 1
			end



		end


	run_mearurements_detail(data : ARRAY[INTEGER]; f: FUNCTION[ANY, TUPLE[ARRAY[INTEGER]], INTEGER_64]; min_size, array_size, n : INTEGER_32)
		local
			base_time  : DOUBLE
		do
			    base_time := measure(data, f, n);

			    print(array_size)
			    print(";")
			    print(n)
			    print(";")
			    print(n * 0.6)
			    print(";")
			    print(base_time)
			    print(";")
			    print(base_time / (n * 0.6))
			    print(";")
			    print(base_time / (n * 0.6 * array_size))
			    print("%N")
		end


	run_mearurements_detail_32(data : ARRAY[INTEGER]; f: FUNCTION[ANY, TUPLE[ARRAY[INTEGER]], INTEGER_32]; min_size, array_size, n : INTEGER_32)
		local
			base_time  : DOUBLE
		do
			    base_time := measure_32(data, f, n);

			    print(array_size)
			    print(";")
			    print(n)
			    print(";")
			    print(n * 0.6)
			    print(";")
			    print(base_time)
			    print(";")
			    print(base_time / (n * 0.6))
			    print(";")
			    print(base_time / (n * 0.6 * array_size))
			    print("%N")
		end

	run_mearurements( min_size, max_size : INTEGER_32)
		local
			array_size : INTEGER_32
			n          : INTEGER_32
			base_time  : DOUBLE
			data       : ARRAY[INTEGER];
		do

			from
				array_size := min_size
			    n := 10
			until
				array_size >  max_size
			loop
				data := tools.create_random_array(array_size)

				run_mearurements_detail   (data, agent sum_original, min_size, array_size, n)
				run_mearurements_detail_32(data, agent sum_original_32, min_size, array_size, n)
				run_mearurements_detail   (data, agent sum_original_across, min_size, array_size, n)
				run_mearurements_detail_32(data, agent sum_original_across_32, min_size, array_size, n)
				run_mearurements_detail   (data, agent sum_local_count, min_size, array_size, n)
				run_mearurements_detail   (data, agent sum_type_mismatch, min_size, array_size, n)
				run_mearurements_detail   (data, agent sum_type_mismatch_64, min_size, array_size, n)
				run_mearurements_detail   (data, agent sum_local_count_type_mismatch, min_size, array_size, n)
				run_mearurements_detail   (data, agent sum_local_count_type_mismatch_64, min_size, array_size, n)
				run_mearurements_detail   (data, agent sum_just_special, min_size, array_size, n)
				run_mearurements_detail   (data, agent sum_alex, min_size, array_size, n)
				run_mearurements_detail   (data, agent sum_alex_type_mismatch_64, min_size, array_size, n)

				array_size := array_size * 2
			end
		end




	make
		local
			min_size: INTEGER_32
			max_size: INTEGER_32
			t1: INTEGER_64
			t2: INTEGER_64
			diff : INTEGER_64

		do
			min_size := 8
			max_size := 16 * 1024 * 1024

			create tools.make
			tools.initialize_random_generator

			run_mearurements(min_size, max_size)

		end
end

