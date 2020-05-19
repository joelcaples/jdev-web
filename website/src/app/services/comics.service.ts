import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class ComicsService {

  constructor(private http: HttpClient) {}

  public getComics():Observable<any> {
      return this.http.get<any>("../assets/server/bin/hello.php");
  }

}
