import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { TechData } from '../models/tech.model';

@Injectable({
  providedIn: 'root'
})
export class TechDataService {

  constructor(private http: HttpClient) {}

  public getTechData():Observable<TechData> {
      return this.http.get<TechData>("../assets/data/tech-data.json");
  }

}
