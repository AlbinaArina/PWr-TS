#!/usr/bin/perl

# Aby serwer wysyłał do klienta nagłówek jego żądania wystarczyła prosta modyfikacja wewnętrznej pętli 
# programu. Najpierw tworzę zmienną przechowującą nagłówek requesta, potem tworzę nową odpowiedź 
# o kodzie 200 (OK, znaczenie - zawartość żądanego dokumentu), ustawiam jej typ na dane tekstowe oraz 
# nadaję jej zawartość, w postaci wartości trzymanej przez zmienną h, a na końcu odsyłam do klienta.

use HTTP::Daemon;
use HTTP::Status;  
use IO::File;

my $d = HTTP::Daemon->new(LocalAddr => 'localhost', LocalPort => 4321,)|| die;
  
print "Please contact me at: <URL:", $d->url, ">\n";

while (my $c = $d->accept) {
    while (my $r = $c->get_request) {
        if ($r->method eq 'GET') {  
            my $h = $r->headers_as_string; # Pobranie nagłówków żądania i przypisanie ich do zmiennej $h.
            my $resp = HTTP::Response->new(200); # Utworzenie nowego obiektu klasy HTTP::Response z kodem odpowiedzi 200 (OK).
            $resp->header("Content-Type" => "text/plain"); # Ustawienie nagłówka "Content-Type" na "text/plain".
            $resp->content($h); # Ustawienie zawartości odpowiedzi na nagłówki żądania.
            $c->send_response($resp); # Wysłanie odpowiedzi do klienta, przesyłając obiekt $resp.
        }
        else {
            $c->send_error(RC_FORBIDDEN);
        }
    }
    $c->close;
    undef($c);
}
