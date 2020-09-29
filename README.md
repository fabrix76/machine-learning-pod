# **machine-learning-pod**
# Introduction
Datascience is a intense activity, made by sessions of data clean, sessions of training and compare result of the models and, finally, get it in production.

In enterprise there are a lot of way to achieve this, but at home it's a little bit different, being a developer, often i need to adjust something and git is usefull to take note of what I'm doing, so i decited do add it, the second need has been to schedule runs of my jobs. Datamining jobs, but also forecast jobs, because obviously at the end I would like to get forecast from my neuralnets and something must run it at specific time, so I decided to use Cron, but inside a container it's ugly to use, so I included a great web frontend found here on [github] (https://github.com/alseambusher/crontab-ui), thanks to Suresh Alse.

# Available Kernels
Staring from Python, adding nice features like cron and git i decided to add also other kernel, because changing scenario some needs are the same (scheduling and versioning). Jupyter is really cool and I asked myself why create another thing to do the same work? 

So I added following kernels:

* Bash
* Julia
* Octave
* PHP
* Scilab

# Build and use this pod

After built, the usage of this pod is really easy, It's a good idea to give a volume for /opt/jupyter filesystem, so your work will survive at any update of your docker image, only exclusion is crontables, **attention** use backup feature of the gui and save them on your /opt/docker filesystem or everywwhere you like.

# Access to the services
Upon up and running you can access your jupyterlab on port 8888, git web-ui on port 8000 and cron web-ui on port 80. For the first run, you need the token to access to jupyterlab and set a password, you can get it looking at **/var/log/jupyter_stdout.log** or **/var/log/jupyter_stderr.log** inside container. In future i like to show it in docker logs.
