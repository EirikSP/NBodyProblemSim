#version 430

#define particle_count 1;
uniform float dt;


const float G = 0.005;

layout(local_size_x=particle_count) in;

struct Particle
{
    float pos_x, pos_y;
    float vel_x, vel_y;
    float mass;
};


layout(std430, binding=0) buffer particles_in
{
    Particle particles[];
} In;
layout(std430, binding=1) buffer particles_out
{
    Particle particles[];
} Out;



float angle_2_vec(vec2 vec_1, vec2 vec_2){
    return acos(dot(vec_1, vec_2)/(max(0.001, length(vec_1))*max(0.001, length(vec_2))));
}


vec2 rotate_vec(vec2 vec){
    return vec2(-vec.y, vec.x);
}



vec2 collision(vec2 pos_1, vec2 pos_2, vec2 vel_1, vec2 vel_2, float mass_1, float mass_2){
    /* float theta_1 = angle_2_vec(pos_2 - pos_1, vel_1);
    float theta_2 = angle_2_vec(pos_1 - pos_2, vel_2);

    float vp1 = sin(theta_1)*length(vel_1);

    float vc1 = cos(theta_1)*length(vel_1);
    float vc2 = -cos(theta_2)*length(vel_2);

    float vf1 = (mass_1*vc1 - mass_2*(vc1 - 2.0*vc2))/(mass_1 + mass_2); */

    vec2 vf = vel_1 - ((2.0*mass_2)/(mass_1 + mass_2))*(dot(vel_1 - vel_2, pos_1 - pos_2)/(pow(length(pos_1 - pos_2), 2)))*(pos_1 - pos_2);

    return vf;

    //return vf1*normalize(pos_2 - pos_1) + vp1*rotate_vec(pos_2 - pos_1);

}



void main()
{
    int x = int(gl_GlobalInvocationID);

    Particle in_particle = In.particles[x];

    vec2 in_pos = vec2(in_particle.pos_x, in_particle.pos_y);
    vec2 in_vel = vec2(in_particle.vel_x, in_particle.vel_y);
    float mass = in_particle.mass;

    vec2 out_pos = in_pos;
    vec2 out_vel = in_vel;
    vec2 acc = vec2(0.0, 0.0);
    


    /* for (int i=0; i<=particle_count; i++){
        vec2 other_particle_pos;
        vec2 other_particle_vel;
        float other_particle_mass;

        if(i!=x){
            other_particle_pos = vec2(In.particles[i].pos_x, In.particles[i].pos_y);
            other_particle_vel = vec2(In.particles[i].vel_x, In.particles[i].vel_y);
            other_particle_mass = In.particles[i].mass;
            acc += normalize(other_particle_pos - in_pos)*G*other_particle_mass/(pow(length(other_particle_pos - in_pos), 2));
        }
    } */

    /* if(length(in_pos)>0.07){
        acc = -normalize(in_pos)*G/pow(length(in_pos), 2.0);
    }
 */

    out_vel = -vec2(0.0*in_pos.x + in_pos.y, -4.0*in_pos.x + 0.0*in_pos.y)*dt;
    out_pos += out_vel*dt*3.0;

    /* for (int i=0; i<=particle_count; i++){

        vec2 other_particle_pos;
        vec2 other_particle_vel;
        float other_particle_mass;

        if(i!=x){
            other_particle_pos = vec2(In.particles[i].pos_x, In.particles[i].pos_y);
            other_particle_vel = vec2(In.particles[i].vel_x, In.particles[i].vel_y);
            other_particle_mass = In.particles[i].mass;

            if(length(in_pos - other_particle_pos)< 2*0.010){
                //out_vel *= -1.0;
                out_vel = collision(in_pos, other_particle_pos, out_vel, other_particle_vel, mass, other_particle_mass);
                //out_pos = in_pos + out_vel*dt*10;
                out_pos = in_pos + out_vel*dt;
            }
        }
    } */


    /* if(out_pos.x < -0.99 || out_pos.x > 0.99){
        out_vel.x *= -0.97;
        out_pos.x = in_pos.x;
    }
    if(out_pos.y < -0.99 || out_pos.y > 0.99){
        out_vel.y *= -0.97;
        out_pos.y = in_pos.y;

    } */


    Particle out_particle;

    out_particle.pos_x = out_pos.x;
    out_particle.pos_y = out_pos.y;
    out_particle.vel_x = out_vel.x;
    out_particle.vel_y = out_vel.y;
    out_particle.mass = mass;


    Out.particles[x] = out_particle;
}