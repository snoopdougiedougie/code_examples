package main

import (
	"encoding/json"
	"fmt"
	"net/http"
	"os"
)

func main() {
	http.HandleFunc("/pets", get_pet_json)
	fmt.Printf("API endpoint -> http://localhost:8080/pets")
	err := http.ListenAndServe(":8080", nil)
	if err != nil {
		fmt.Println("Got an error connecting to 8080, goodbye!")
		os.Exit(1)
	}
}

type Pet struct {
	Id          string `json:"id"`
	Name        string `json:"name"`
	Breed       string `json:"breed"`
	Temperament string `json:"temperament"`
}

var pets = map[string]Pet{
	"0000000000": {Id: "101", Name: "Bella", Breed: "Lab", Temperament: "Happy"},
	"0000000001": {Id: "102", Name: "Fido", Breed: "Mutt", Temperament: "Cautious"},
	"0000000002": {Id: "103", Name: "Snoopy", Breed: "Beagle", Temperament: "Friendly"},
	"0000000003": {Id: "104", Name: "RinTinTim", Breed: "German Shephard", Temperament: "Protective"},
}

func get_pets() []Pet {
	values := make([]Pet, len(pets))
	i := 0
	for _, emp := range pets {
		values[i] = emp
		i++
	}
	return values
}

func get_pet_json(w http.ResponseWriter, r *http.Request) {
	emps := get_pets()
	data, err := json.Marshal(emps)
	if err != nil {
		panic(err)
	}
	w.Header().Add("Content-Type", "application/json; charset=utf-8")
	_, err = w.Write(data)

	if err != nil {
		fmt.Println("Got an error writing data, goodbye!")
		os.Exit(1)
	}
}
