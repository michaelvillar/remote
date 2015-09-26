#itachIP2IR

A tiny objective-c library for itach IP2IR devices.

##Usage

<https://gist.github.com/colossus689/11100982>

```obj-c
itachIP2IR *remote = [itachIP2IR sharedInstance];
/*add individual commands or set them all at once setCommandList: */
[remote.commandList addObject:@"crazy long ir blast command" forKey:@"VOL_UP"];
/* set itach ip */
[remote setItachIp:@"192.168.1.10"];
/* send command */
[remote sendCommand:@"VOL_UP"];
```


