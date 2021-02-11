// Licensed under the terms of the GNU GPL v3, or any later version.
//
// Copyright 2021 Cristi Constantin <cristi.constantin@sent.com>
//
// Initially based on i3blocks-contrib/cpu_usage2
// Also inspired by procps/proc/sysinfo.c, busybox/procps/top.c

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <getopt.h>

#define WARN_C "#CC241D"
#define CRIT_C "#D65D0E"
#define MAX_CPUS 10
#define MAX_VALU 9.0

typedef unsigned long long int ulli;

struct ProcStat
{
    ulli old_used;
    ulli old_total;
    ulli new_used;
    ulli new_total;
};

struct ProcStat proc_stats[MAX_CPUS];

const char fmt[] = "cpu%[^ ] %llu %llu %llu %llu %llu %llu %llu %llu %llu %llu";
// largest CPU line I have seen is 63
char line_buf[64];
ulli used, user, nic, sys, idle, iowait, irq, sirq, steal, guest, nguest;
double usage;
char scpu;
uint icpu;

void help(char *argv[])
{
    printf("Usage: %s "
           "[-t seconds] [-w %%age] [-c %%age] [-l label] [-h]\n",
           argv[0]);
    printf("\n");
    printf("-t seconds\tSet refresh time (default is 1)\n");
    printf("-l label\tLabel to print before the cpu usage (default: CPU)\n");
    printf("-w \t\tSet warning color for CPU usage. (default: %s)\n", WARN_C);
    printf("-c \t\tSet critical color for CPU usage. (default: %s)\n", CRIT_C);
    printf("-h \t\tthis help\n");
    printf("\n");
}

void display(const char *label, uint const warning, uint const critical)
{
    printf("%s<span>", label);

    for (uint i = 0; i < MAX_CPUS; i++)
    {
        if (proc_stats[i].old_total < 1)
        {
            break;
        }
        usage = MAX_VALU *
                (proc_stats[i].new_used - proc_stats[i].old_used) /
                (proc_stats[i].new_total - proc_stats[i].old_total);

        if (i > 0)
        {
            // space in between
            printf(" ");
        }
        if (critical > 0 && usage >= critical)
        {
            printf("<span color='%s'>%i=%d</span> ", WARN_C, i, (int)usage);
        }
        else if (warning > 0 && usage >= warning)
        {
            printf("<span color='%s'>%i=%d</span> ", CRIT_C, i, (int)usage);
        }
        else
        {
            printf("%i=%d", i, (int)usage);
        }
    }

    printf("</span>\n");
}

void update_cpu_line(FILE *fp)
{
    if (!fgets(line_buf, sizeof(line_buf), fp) || line_buf[0] != 'c' /* not "cpu" */)
    {
        return;
    }
    int ret = sscanf(line_buf, fmt,
                     &scpu, &user, &nic, &sys, &idle, &iowait, &irq, &sirq, &steal,
                     &guest, &nguest);
    if (ret > 10)
    {
        icpu = atoi(&scpu);
        used = user + nic + sys + irq + sirq + steal + guest + nguest;
        proc_stats[icpu].new_used = used;
        proc_stats[icpu].new_total = used + idle + iowait;
    }
    return;
}

void read_proc_stat()
{
    FILE *fp = fopen("/proc/stat", "r");
    if (fp == NULL)
    {
        perror("Couldn't open /proc/stat\n");
        exit(EXIT_FAILURE);
    }
    for (uint i = 0; i < MAX_CPUS + 2; i++)
    {
        // the function will only update matching lines
        update_cpu_line(fp);
    }
    return;
}

int main(int argc, char *argv[])
{
    uint warning = (int)(0.9 * MAX_VALU);
    uint critical = (int)(0.75 * MAX_VALU);
    char *label = "";
    char *envvar = NULL;
    int c, t = 1;

    envvar = getenv("REFRESH_TIME");
    if (envvar)
        t = atoi(envvar);
    envvar = getenv("WARN_PERCENT");
    if (envvar)
        warning = atoi(envvar);
    envvar = getenv("CRIT_PERCENT");
    if (envvar)
        critical = atoi(envvar);
    envvar = getenv("LABEL");
    if (envvar)
        label = envvar;

    while (c = getopt(argc, argv, "ht:w:c:d:l:"), c != -1)
    {
        switch (c)
        {
        case 't':
            t = atoi(optarg);
            break;
        case 'w':
            warning = atoi(optarg);
            break;
        case 'c':
            critical = atoi(optarg);
            break;
        case 'l':
            label = optarg;
            break;
        case 'h':
            help(argv);
            return EXIT_SUCCESS;
        }
    }

    // printf("Label=%s, W=%d, C=%d\n", label, warning, critical);

    read_proc_stat();
    for (uint i = 0; i < MAX_CPUS; i++)
    {
        proc_stats[i].old_used = proc_stats[i].new_used;
        proc_stats[i].old_total = proc_stats[i].new_total;
    }

    while (1)
    {
        sleep(t);
        read_proc_stat();
        display(label, warning, critical);
        fflush(stdout);

        for (uint i = 0; i < MAX_CPUS; i++)
        {
            proc_stats[i].old_used = proc_stats[i].new_used;
            proc_stats[i].old_total = proc_stats[i].new_total;
        }
    }

    return EXIT_SUCCESS;
}
