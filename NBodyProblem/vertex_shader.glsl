#version 430

in vec2 in_vert;
in float mass;

out float v_mass;

void main()
{
    gl_Position = vec4(in_vert, 1.0, 1.0); // x, y
    v_mass = mass;
}