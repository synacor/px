Pipe X-Ray (`px`) is a Linux tool that analyzes the pipeline it's in or the pipline for the given pid.

If you process large datasets using long-running Linux command pipelines (like `cat | grep`, [`dtk`](https://github.com/synacor/dtk), or even custom scripts), `px` can give you live progress and status information for your job. `px` functions without any changes to the underlying commands, and doesn't handle data directly (thereby avoiding memory allocation and throughput limitations).

There are two primary modes of execution:
- Fork and exec another process, then observe that process: `px <cmd> [<args>...]`
- Observe a specific process directly: `px --pid <pid>`

The process being observed and *all processes related by pipes* are then analyzed for expected file accesses (by looking at their standard input and command line arguments) and monitored for reads on those files.

`px` handles many situations. It is written in Perl, and relies only on built-in packages. It should work in any terminal width, and will omit parts of its output to fit your terminal, even if you resize your terminal while it is running. It will pause its output if it is in the background (such as via ctrl-Z).

For invocation options, see `px --help`.

# Examples

Several runnable demos are available in the `demos/` directory. Here are a few examples of invocations and output:

---

If you use px to invoke one of the commands in your pipeline like this:

```
px zcat /var/log/rotated/access_log.*.gz | grep favicon | wc -l
```

It will produce a live progress report in your terminal like this:

```
zcat 18413 R [========            ]  41.09% (33/60 files, 7.49 MB @ 4.36 MB/s, ETA 2.463s)
```

---

This even works across subshells, pipelines that spawn new processes, or if the invoked command isn't the one doing the reading:

```
for f in /var/log/rotated/access_log.*.gz; do
  cat $f
done | px gunzip | wc -l
```

As new processes are created, they are automatically tracked and added to the list:

```
cat 19261 X [====================] 100.00% (1/1 files, 260.04 KB @ 206.53 KB/s, CPU 0.000s)
cat 19264 X [====================] 100.00% (1/1 files, 255.20 KB @ 230.87 KB/s, CPU 0.000s)
cat 19266 X [====================] 100.00% (1/1 files, 239.63 KB @ 231.23 KB/s, CPU 0.000s)
cat 19268 S [===============     ]  76.14% (1/1 files, 172.00 KB @ 226.91 KB/s, ETA 0.238s)
```

---

If you want to watch an already-running pipeline (or even a single command):

```
dd if=/dev/sda of=/dev/sdb
```

You can pass a PID of any process in it:

```
px --pid `pgrep -n dd`
```

...and you will be presented with the same progress information:

```
dd 19643 R [===============     ]  75.72% (1/1 files, 474.02 MB @ 28.68 MB/s, ETA 5.299s)
```

# Technical Details

`px` only works in environments that have a compatible `/proc` filesystem (probably only Linux); specifically, it looks in `/proc/<pid>/` for `cwd`, `cmdline`, `stat`, `fd/<fd>`, `fdinfo/<fd>`, and expects pipes to be identified as `fd/<fd>` links to a string like `pipe:12345`.  It uses the list of files passed to each command  (and any file open on STDIN) to determine the maximum number of bytes expected to be read.
