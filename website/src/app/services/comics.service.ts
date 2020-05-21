import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { Series } from '../models/comics.series.model';
import { map } from 'rxjs/operators';
import { Issue } from '../models/comics.issue.model';
import { Page } from '../models/comics.page.model';
import { StoryArc } from '../models/comics.storyArc.model';

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

  public getPages(issueId:number):Observable<Page[]> {
    return this.http
    .get<Page[]>(`http://localhost/server/comics/pages.php?issueid=${issueId}`)
    .pipe(map(results=><Page[]>results));
  }  

  public getStoryArcs(pageId:number):Observable<StoryArc[]> {
    return this.http
    .get<StoryArc[]>(`http://localhost/server/comics/storyarcs.php?pageid=${pageId}`)
    .pipe(map(results=><StoryArc[]>results));
  }  
}
