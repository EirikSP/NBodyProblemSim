#version 430

layout(points) in;
layout(triangle_strip, max_vertices=4) out;

in float v_mass[];
out vec2 uv;
out vec4 color;

void main() {
    float radius = 0.002;
    vec2 pos = gl_in[0].gl_Position.xy;

    // Emit the triangle strip creating a "quad"
    // Lower left
    gl_Position = vec4(pos + vec2(-radius, -radius), 0, 1);
    color = vec4((pos.x + 1.0)/2.0, (pos.y + 1.0)/2.0, v_mass[0]/12.0, 1.0);
    uv = vec2(0, 0);
    EmitVertex();

    // upper left
    gl_Position = vec4(pos + vec2(-radius, radius), 0, 1);
    color = vec4((pos.x + 1.0)/2.0, (pos.y + 1.0)/2.0, v_mass[0]/12.0, 1.0);
    uv = vec2(0, 1);
    EmitVertex();

    // lower right
    gl_Position = vec4(pos + vec2(radius, -radius), 0, 1);
    color = vec4((pos.x + 1.0)/2.0, (pos.y + 1.0)/2.0, v_mass[0]/12.0, 1.0);
    uv = vec2(1, 0);
    EmitVertex();

    // upper right
    gl_Position = vec4(pos + vec2(radius, radius), 0, 1);
    color = vec4((pos.x + 1.0)/2.0, (pos.y + 1.0)/2.0, v_mass[0]/12.0, 1.0);
    uv = vec2(1, 1);
    EmitVertex();

    EndPrimitive();
}