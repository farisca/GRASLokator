var map;
var linija;
var markeri = [];
document.getElementsByName("tipVozila")[0].selectedIndex = -1;

document.getElementsByName("tipVozila")[0].addEventListener("change", function() {
    var ajax = new XMLHttpRequest();
    ajax.onreadystatechange = function() { // Anonimna funkcija
        if (ajax.readyState == 4 && ajax.status == 200) {
			var result = ajax.responseText;
			result = result.replace("<!-- Hosting24 Analytics Code -->", "");
			result = result.replace("<script type=\"text/javascript\" src=\"http://stats.hosting24.com/count.php\"></script>", "");
			result = result.replace("<!-- End Of Analytics Code -->", "");
            var obj = JSON.parse(result);
            for (i = 0; i <= obj.linije.length - 1; i++) {
                document.getElementsByName("linija")[0].innerHTML += '<option value="' + obj.linije[i].idLinije + '">' + obj.linije[i].smjer + '</option>';
            }
            document.getElementsByName("linija")[0].selectedIndex = -1;
        }
        if (ajax.readyState == 4 && ajax.status == 404)
            document.getElementById("polje").innerHTML = "Greska: nepoznat URL";
    }
    ajax.open("GET", "http://farisc.comlu.com/Linije.php?tipVozila=" + (document.getElementsByName("tipVozila")[0].selectedIndex + 1), true);
    ajax.send();
});

document.getElementsByName("linija")[0].addEventListener("change", prikaziLiniju);

function prikaziLiniju() {
    var idLinije = document.getElementsByName("linija")[0].value;
    var ajax = new XMLHttpRequest();
    ajax.onreadystatechange = function() { // Anonimna funkcija
        if (ajax.readyState == 4 && ajax.status == 200) {
            if (linija != null) linija.setMap(null);
            var result = ajax.responseText;
			result = result.replace("<!-- Hosting24 Analytics Code -->", "");
			result = result.replace("<script type=\"text/javascript\" src=\"http://stats.hosting24.com/count.php\"></script>", "");
			result = result.replace("<!-- End Of Analytics Code -->", "");
            var obj = JSON.parse(result);
            var koordinateStanica = [];

            for (i = 0; i <= obj.stanice.length - 1; i++) {
                koordinateStanica.push(new google.maps.LatLng(obj.stanice[i].lat, obj.stanice[i].lon));
            }
            linija = new google.maps.Polyline({
                path: koordinateStanica,
                geodesic: true,
                strokeColor: '#FF0000',
                strokeOpacity: 1.0,
                strokeWeight: 2
            });
            linija.setMap(map);
            zoomirajIzmedjuDvijeTacke(koordinateStanica[0], koordinateStanica[koordinateStanica.length - 1]);
        }
        if (ajax.readyState == 4 && ajax.status == 404)
            document.getElementById("polje").innerHTML = "Greska: nepoznat URL";

    }
    ajax.open("GET", "http://farisc.comlu.com/Stanice.php?idLinije=" + idLinije, true);
    ajax.send();
}

function zoomirajIzmedjuDvijeTacke(prva, druga) {
    map.setCenter(new google.maps.LatLng(
        ((prva.lat() + druga.lat()) / 10.0), ((prva.lng() + druga.lng()) / 10.0)
    ));
    map.fitBounds(new google.maps.LatLngBounds(
        new google.maps.LatLng(prva.lat(), prva.lng()),
        new google.maps.LatLng(druga.lat(), druga.lng())
    ));
    prikaziAktivnaVozila();
}

function prikaziAktivnaVozila() {
    var ajax = new XMLHttpRequest();
    ajax.onreadystatechange = function() { // Anonimna funkcija
        if (ajax.readyState == 4 && ajax.status == 200) {
            for (var i = 0; i < markeri.length; i++)
                markeri[i].setMap(null);
            var result = ajax.responseText;
			result = result.replace("<!-- Hosting24 Analytics Code -->", "");
			result = result.replace("<script type=\"text/javascript\" src=\"http://stats.hosting24.com/count.php\"></script>", "");
			result = result.replace("<!-- End Of Analytics Code -->", "");
            var obj = JSON.parse(result);
            for (i = 0; i <= obj.voznje.length - 1; i++) {
                markeri.push(new google.maps.Marker({
                    position: new google.maps.LatLng(obj.voznje[i].lat, obj.voznje[i].lon),
                    map: map
                }));
            }
        }
        if (ajax.readyState == 4 && ajax.status == 404)
            document.getElementById("polje").innerHTML = "Greska: nepoznat URL";
    }
    ajax.open("GET", "http://farisc.comlu.com/Voznje.php?idLinije=" + (document.getElementsByName("linija")[0].value), true);
    ajax.send();
}


function initialize() {
    var mapCanvas = document.getElementById('map-canvas');
    var mapOptions = {
        center: new google.maps.LatLng(43.857019, 18.403580),
        zoom: 12,
        mapTypeId: google.maps.MapTypeId.ROADMAP
    }
    map = new google.maps.Map(mapCanvas, mapOptions);

}

google.maps.event.addDomListener(window, 'load', initialize);