/*
 * vrrp_mac.c - MAC address info.
 *
 * Copyright (C) 2014 Samuel Melrose & Glenn Townsend
 * Credit to coding example from here: http://www.humbug.in/2014/find-network-interface-mac-address-programatically-linux/
 *
 * This file is part of uvrrpd.
 *
 * uvrrpd is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * uvrrpd is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with uvrrpd.  If not, see <http://www.gnu.org/licenses/>.
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

int mac_get_binary(char *ifname, unsigned char * mac) {
    int status = 1;
    char buf[256];
    
    const char *prefix = "/sys/class/net/";
    const char *suffix = "/address";
    
    char *filename = (char *) malloc(strlen(prefix) + strlen(suffix) + strlen(ifname));
    
    strcpy(filename, prefix);
    strcat(filename, ifname);
    strcat(filename, suffix);
    
    FILE *fp = fopen(filename, "rt");
    memset(buf, 0, 256);
    if (fp) {
        if (fgets(buf, sizeof buf, fp) != NULL) {
            sscanf(buf, "%hhx:%hhx:%hhx:%hhx:%hhx:%hhx", &mac[0], &mac[1], &mac[2], &mac[3], &mac[4], &mac[5]);
            status = 0;
        }
        fclose(fp);
    }
    return status;
}