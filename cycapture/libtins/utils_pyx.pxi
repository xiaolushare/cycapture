# -*- coding: utf-8 -*-

cdef class RouteEntry(object):
    def __init__(self, interface, destination, gateway, mask):
        self.interface = bytes(interface)
        self.destination = IPv4Address(destination)
        self.gateway = IPv4Address(gateway)
        self.mask = IPv4Address(mask)

    def __str__(self):
        return b"Interface: {}    Destination: {}    Gateway: {}    Mask: {}".format(
            self.interface, str(self.destination), str(self.gateway), str(self.mask)
        )

    def __repr__(self):
        return b"RouteEntry('{}', '{}', '{}', '{}')".format(
            self.interface, str(self.destination), str(self.gateway), str(self.mask)
        )

cpdef get_route_entries():
    cdef vector[cppRouteEntry] v = route_entries()
    cdef vector[cppRouteEntry].iterator it = v.begin()
    cdef cppRouteEntry cpproute
    results = []
    while it != v.end():
        cpproute = deref(it)
        results.append(
            RouteEntry(
                <bytes>cpproute.interface, <bytes>cpproute.destination.to_string(), <bytes>cpproute.gateway.to_string(),
                <bytes>cpproute.mask.to_string()
            )
        )
        inc(it)
    return results

cpdef list_network_interfaces():
    return <set> cpp_network_interfaces()

cpdef pdutype_to_string(int t):
    return <bytes> cpp_pdutype_to_string(<PDUType> t)
