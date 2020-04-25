import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';

@Injectable({
  providedIn: 'root'
})
export class WebRequestService {

  constructor(public http: HttpClient) { }

  public makeRequest() {
    return this.http.get(`http://localhost:4200/`, {responseType: 'text' });
  }

}
