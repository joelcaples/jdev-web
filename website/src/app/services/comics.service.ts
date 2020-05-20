import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { Series } from '../models/comics.series.model';
import { map } from 'rxjs/operators';

@Injectable({
  providedIn: 'root'
})
export class ComicsService {

  constructor(private http: HttpClient) {}

  public getComics():Observable<Series[]> {
    return this.http
    .get<Series[]>(`http://localhost/server/comics/series.php`)
    .pipe(map(results=><Series[]>results));
  }  
}
