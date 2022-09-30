#version 430

in vec2 uv;
in vec4 color;

out vec4 out_color;

void main()
{
    // Calculate the length from the center of the "quad"
    // using texture coordinates discarding fragments
    // further away than 0.5 creating a circle.
    if (length(vec2(0.5, 0.5) - uv.xy) > 0.5)
    {
        discard;
    }
    out_color = color;
}