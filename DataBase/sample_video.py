import subprocess as sp

if __name__ == '__main__':
    FFMPEG_BIN = "ffmpeg"
    command = [ FFMPEG_BIN,
        '-y', # (optional) overwrite output file if it exists
        '-f', 'mpeg',
        '-vcodec','mpeg',
    #    '-s', '420x360', # size of one frame
        '-pix_fmt', 'rgb24',
        '-r', '24', # frames per second
        '-i', '-', # The imput comes from a pipe
    #    '-an', # Tells FFMPEG not to expect any audio
        '-vcodec', 'mpeg',
        'my_output_videofile.mp4' ]

pipe = sp.Popen( command, stdin=sp.PIPE, stderr=sp.PIPE)



