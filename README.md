# Dogecoin Core in a Docker container

Run a Dogecoin fullnode in a Docker container / swarm stack

**But why should I do that?!**

* To support the Dogecoin community.
* Just for the sake of doing it.
* Because it's fun.

## How to install

**Make sure that port 22556 is being forwarded on your router!**

It's not that hard, actually. There are two ways to get it up and running:

### Pull and run the image from the [Docker Store](https://hub.docker.com/r/jkubo/dogecoin-core)

You can deploy a stack in Docker swarm mode
```bash
docker stack deploy -c docker-stack.yml dogecoin
```
Or also deploy standalone containers
```bash
docker run -p 22556:22556 -v /mnt/ssd/dogecoin:/home/dogecoin/.dogecoin jkubo/dogecoin-core:latest
```

Change the value for `/mnt/ssd/dogecoin` above to an absolute path on your system where Dogecoin Core can store the blockchain data.

It is possible to run without a volume, however the blockchain data will be deleted each time you run it.  This may not be wise as 
it can take days to download the full blockchain.

Boom, your Dogecoin node is up and running!

### Custom command line arguments

By default, the image runs ```dogecoind -printtoconsole``` as the command.  You can customize the command arguments if desired.  
Here's an example of a customized command argument for -maxuploadtarget=20000.

```bash

docker run -p 22556:22556 -v /mnt/ssd/dogecoin:/home/dogecoin/.dogecoin jkubo/dogecoin-core:latest dogecoind -printtoconsole -maxuploadtarget=20000

```

## How to build

The build assumes the web links for Dogecoin Core will be consistent: https://github.com/dogecoin/dogecoin/releases

Given that, version must be specified on the commandline.  The build is run as follows:

```bash

sudo docker build --build-arg version=1.14.6 . -t=dogecoin-core:latest

```

## Optional: kickstart the node with a bootstrap file

Initial sync may take a looooong time (total blockchain size as of writing is over 50 GB!). That's why it may be useful to have a bootstrap file to make the initial sync process a little faster.

You can get the bootstrap.dat file from:

* [this reddit thread](https://www.reddit.com/r/dogecoin/comments/mtzwdh/latest_dogecoin_core_bootstrap_11th_april_2021/))

Sit back and relax while it's downloading. It's a large file, so it may take some time.

Copy the bootstrap.dat file to the mapped volume directory as shown above, /localfolder/dogevolume is our example.

Once the node has imported the bootstrap.dat file, it'll be renamed to bootstrap.dat.old.

**TO THE MOON!!!**