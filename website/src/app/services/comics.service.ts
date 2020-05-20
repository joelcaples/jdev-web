import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { Series } from '../models/comics.series.model';
import { map } from 'rxjs/operators';
import { Issue } from '../models/comics.issue.model';

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

  public getIssues(seriesId:number):Observable<Issue[]> {
    return this.http
    .get<Issue[]>(`http://localhost/server/comics/issues.php?id=${seriesId}`)
    .pipe(map(results=><Issue[]>results));
  }  
}
