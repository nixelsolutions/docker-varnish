
sub vcl_recv {
 set req.backend_hint = default_director;
}
