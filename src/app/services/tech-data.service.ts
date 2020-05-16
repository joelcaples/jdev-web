import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { TechData } from '../models/tech.model';

@Injectable({
  providedIn: 'root'
})
export class TechDataService {

  constructor(private http: HttpClient) {
    // this.getJSON().subscribe(data => {
    //     console.log(data);
    // });
  }

  public getTechData() {
      return this.http.get<TechData>("./assets/data/tech-data.json");
  }

}
