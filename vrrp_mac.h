/*
 * vrrp_mac.h
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

int mac_get_binary(char *ifname, unsigned char * mac);