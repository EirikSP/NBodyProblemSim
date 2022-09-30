import math
import moderngl_window as mglw
from moderngl_window import geometry
from numpy import pi
import numpy as np


class App(mglw.WindowConfig):
    window_size = 900, 900
    resource_dir = "NBodyProblem"
    vsync = False
    gl_version = (4, 3)
    aspect_ratio = None

    def __init__(self, **kwargs):
        super().__init__(**kwargs)

        self.framerate = 200
        self.update = False

        """
        Data Strucure 2f position, 2f velocity 1f weight
        -1.0 < Position < 1.0
        """
        self.local_size = 1000
        
        self.particle_count = 15000
        self.group_size = int(math.ceil(self.particle_count / self.local_size))

        #self.particles = np.array([-0.3, -0.5, 0.1, 0.0, 1.0, 0.5, -0.3, 0.0,0.1, 1.0, 0.0, 0.6, 0.0, -0.1, 1.0]).astype('f4')
        self.particles = np.fromiter(self.generate_particles(self.particle_count), dtype='f4')

        self.particle_buffer_1 = self.ctx.buffer(data=self.particles)
        self.particle_buffer_2 = self.ctx.buffer(data=self.particles)


        self.render_program = self.load_program(vertex_shader='vertex_shader.glsl',geometry_shader='geometry_shader.glsl', fragment_shader='fragment_shader.glsl')
        self.compute = self.load_compute_shader('compute_shader_time_step.glsl', {'particle_count':self.local_size})

        self.vertex_render_1 = self.ctx.vertex_array(self.render_program, [(self.particle_buffer_1, '2f4 2x4 1f4', 'in_vert', 'mass')])
        self.vertex_render_2 = self.ctx.vertex_array(self.render_program, [(self.particle_buffer_2, '2f4 2x4 1f4', 'in_vert', 'mass')])
        self.last_time = 0.0

    
    def generate_particles(self, N):
        arr = np.array([-1, 1])
        for i in range(N):
            #Position x and y
            yield (np.random.random() + 0.0)*arr[np.random.randint(0,2)]
            yield (np.random.random() + 0.0)*arr[np.random.randint(0,2)]

            #Velocity x and y
            yield (np.random.random()- 0.5)*2.0*0.0
            yield (np.random.random()- 0.5)*2.0*0.0

            #Mass
            yield (np.random.random() + 0.2)*10

        



    def render(self, time: float, frame_time: float):
        self.ctx.clear()
        self.compute['dt'] = frame_time
        self.particle_buffer_1.bind_to_storage_buffer(0)
        self.particle_buffer_2.bind_to_storage_buffer(1)
        
        
        self.compute.run(group_x=self.group_size)
    
        self.vertex_render_2.render(self.ctx.POINTS)
        self.particle_buffer_1, self.particle_buffer_2 = self.particle_buffer_2, self.particle_buffer_1
        self.vertex_render_1, self.vertex_render_2 = self.vertex_render_2, self.vertex_render_1


        


if __name__=='__main__':
    mglw.run_window_config(App)