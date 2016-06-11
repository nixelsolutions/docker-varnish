acl purge {
 "localhost";
 "10.0.0.0"/8;
}

sub vcl_recv {
 if (req.method == "PURGE") {
  if (client.ip !~ purge) {
   return (synth(405));
  }
  if (req.http.X-Purge-Method == "regex") {
   ban("req.url ~ " + req.url + " && req.http.host ~ " + req.http.host);
   return (synth(200, "Banned."));
  } else {
   return (purge);
  }
 }

 set req.backend_hint = bar.backend();

 if (req.url ~ "wp-admin|wp-login") {
  return (pass);
 }

 set req.http.cookie = regsuball(req.http.cookie, "wp-settings-\d+=[^;]+(; )?", "");
 set req.http.cookie = regsuball(req.http.cookie, "wp-settings-time-\d+=[^;]+(; )?", "");
 set req.http.cookie = regsuball(req.http.cookie, "wordpress_test_cookie=[^;]+(; )?", "");

 if (req.http.cookie == "") {
  unset req.http.cookie;
 }
}

sub vcl_backend_response {
 if (beresp.ttl == 120s) {
  set beresp.ttl = 1h;
 }

 if (beresp.status == 404) {
  set beresp.ttl = 5s;
 }
}

# how to deliver the output (manipulate output)
sub vcl_deliver {
 # Remove version headers
 unset resp.http.X-Varnish;
 unset resp.http.Via;
 unset resp.http.Age;
 unset resp.http.X-Powered-By;
 unset resp.http.Server;
 set resp.http.Server = "theCore";

 # if a varnish object hits, send X-cache header with HIT
 if (obj.hits > 0) {
  set resp.http.X-Cache = "HIT";
 # otherwise, send X-cache header with MISS
 } else {
  set resp.http.X-Cache = "MISS";
 }
}

