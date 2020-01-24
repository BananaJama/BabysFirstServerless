function UpdateWebPage(e) {
    var inputForm = document.formInputValues;
    getStationData(inputForm.stationId.value);
    getDadJoke();
}

function getStationData (stationID) {
    var url = 'https://derpywebapp.azurewebsites.net/api/GetWaterTemp?StationID=' + stationID;
    var response = fetch(url).then(
        function(response) {
            return response.text();
        }).then(
            function(text) {
                var p = document.getElementById("WaterTempData");
                p.innerHTML = text + 'F';
            }
        );
}

function getDadJoke() {
    var response = fetch('https://icanhazdadjoke.com', {
        headers : {
            'Accept':'application/json'
        }
    }).then(
        function(response) {
            return response.json();
        }).then(
            function(json) {
                var p = document.getElementById("DadJoke");
                    p.innerHTML = "Random Dad Joke<br>" + json.joke;
            }
        )
}        

function getStations (url) {
    var response = fetch(url).then(
        function(response) {
            return response.json();
        }).then(
            function(json) {
                var dropdown = document.getElementById('station-dropdown');
                dropdown.length = 0;
                var defaultOption = document.createElement('option');
                defaultOption.text = 'Choose Weather Station';
                dropdown.add(defaultOption);
                dropdown.selectedIndex = 0;

                var option;
                for (let i = 0; i < json.length; i++) {
                    option = document.createElement('option');
                    option.text = json[i].name;
                    option.value = json[i].id;
                    dropdown.add(option);
                }
            }
        );
}

getStations('https://derpywebapp.blob.core.windows.net/uploads/CoastalStations.json');
getDadJoke();
var inputForm = document.formInputValues;
inputForm.addEventListener("submit", UpdateWebPage);