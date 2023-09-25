shader_type spatial;

void fragment() {
	if (UV.x > 0.5)
	{
	ALBEDO = vec3 (0,0,1);
	}
	else
	{
		ALBEDO = vec3 (0,1,0);
	}

}
