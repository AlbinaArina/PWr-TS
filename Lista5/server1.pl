#!/usr/bin/perl

# Aby program zadziałał, musiałam zmienić parametr LocalAddr z „lukim” na „localhost”. Program 
# uruchamia serwer HTTP, który po otrzymaniu GET request wysyła klientowi plik index.html. W 
# przypadku otrzymania innego requesta, wysyła klientowi błąd 403, informujący o braku dostępu do 
# danego pliku. Utworzyłam plik index.html w tej samej lokalizacji, gdzie zapisałam program i z której go 
# uruchomiłam.

use HTTP::Daemon;
use HTTP::Status;  
use IO::File;

my $d = HTTP::Daemon->new(LocalAddr => 'localhost', LocalPort => 4321,)|| die; # Tworzenie obiektu klasy HTTP::Daemon i przypisanie 
#go do zmiennej $d. Ustawienie lokalnego adresu na 'localhost' i portu na 4321. Jeśli nie można utworzyć obiektu, program zakończy działanie.
  
print "Please contact me at: <URL:", $d->url, ">\n"; # Wyświetlenie komunikatu informującego, gdzie można 
#skontaktować się z serwerem. URL jest pobierany z obiektu $d za pomocą metody url().

while (my $c = $d->accept) { # Pętla while, która akceptuje nowe połączenia klientów i przypisuje je do zmiennej $c.
    while (my $r = $c->get_request) { # Pętla while, która oczekuje na żądania GET od klienta i przypisuje je do zmiennej $r.
        if ($r->method eq 'GET') {  # Warunek sprawdzający, czy metoda żądania jest równa 'GET'
            $file_s= "index.html";  # Przypisanie nazwy pliku do zmiennej $file_s.
            $c->send_file_response($file_s); # Wysłanie odpowiedzi do klienta, przesyłając zawartość pliku $file_s.
        }
        else {
            $c->send_error(RC_FORBIDDEN) # Wysłanie błędu 403 Forbidden do klienta, jeśli metoda żądania nie jest równa 'GET'.
        }
    }
    $c->close; # Zamknięcie połączenia klienta.
    undef($c); # Zniszczenie obiektu klienta.
}
