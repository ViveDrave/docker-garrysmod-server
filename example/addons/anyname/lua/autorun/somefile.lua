local global_I = cookie.GetNumber("key_from_sv_db", 0) + 1
cookie.Set("key_from_sv_db", global_I)

for i = 1, 10 do
	print("Hello world! It's a " .. global_I .. " time when this server starts")
end
