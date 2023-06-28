#!/usr/bin/perl

# Na potrzeby tego zadania utworzyłam folder strona, w którym umieściłam trzy pliki – glowna.html, 
# podstrona1.html oraz podstrona2.html. Aby zrealizować polecenie, zrobiłam kolejną modyfikację pętli 
# programu. Do zmiennej uri zapisuję URI, czyli ścieżkę zasobu, którego dotyczy zapytanie GET. Jest ona 
# jednak niepełna, ponieważ zawiera ona jedynie nazwy plików, a znajdują się one w innym folderze. 
# Dlatego uzupełniam ścieżkę o początek „strona” i dopiero potem odsyłam klientowi żądany zasób.

use HTTP::Daemon;
use HTTP::Status;  
use IO::File;

my $d = HTTP::Daemon->new(LocalAddr => 'localhost', LocalPort => 4320,)|| die;
  
print "Please contact me at: <URL:", $d->url, ">\n";

while (my $c = $d->accept) {
    while (my $r = $c->get_request) {
        if ($r->method eq 'GET') {
            my $uri = $r->uri; # Pobranie URI żądania klienta i przypisanie go do zmiennej $uri.
            if ($uri eq "/") { # Warunek sprawdzający, czy URI jest równa "/".
                $uri = "/glowna.html" # Jeśli tak, zmiana URI na "/glowna.html".
            }
            my $file_s= "strona".$uri; # Utworzenie nazwy pliku na podstawie zmiennej $uri.
            $c->send_file_response($file_s); # Wysłanie odpowiedzi do klienta, przesyłając zawartość pliku $file_s.
        }
        else {
            $c->send_error(RC_FORBIDDEN)
        }
    }
    $c->close;
    undef($c);
}
