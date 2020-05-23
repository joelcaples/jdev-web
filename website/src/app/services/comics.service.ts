import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { Series } from '../models/comics.series.model';
import { map } from 'rxjs/operators';
import { Issue } from '../models/comics.issue.model';
import { Page } from '../models/comics.page.model';
import { StoryArc } from '../models/comics.storyArc.model';
import { SearchResultsRow } from '../models/comics.search-results-row.model';
import { StoryLine } from '../models/comics.story-line.model';

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

  public getIssues(
    seriesId:number,
    issueId:number,
    storyLineId:number,
    storyArcId:number        
  ):Observable<Issue[]> {
    return this.http
    .get<Issue[]>(`http://localhost/server/comics/issues.php?seriesid=${(seriesId>-1?seriesId:"")}&issueid=${(issueId>-1?issueId:"")}&storyarcid=${(storyArcId>-1?storyArcId:"")}&storylineid=${(storyLineId>-1?storyLineId:"")}`)
    .pipe(map(results=><Issue[]>results));
  }  

  public getPages(issueId:number):Observable<Page[]> {

    if(issueId===undefined)
      return Observable.create(function () {
        let pages:Page[] = [];
        return pages;
      });

    return this.http
    .get<Page[]>(`http://localhost/server/comics/pages.php?issueid=${(issueId===undefined ? "" : issueId)}`)
    .pipe(map(results=><Page[]>results));
  }  

  public getStoryLines(
    pageId:number,    
    seriesId:number,
    issueId:number,
    storyLineId:number,
    storyArcId:number,
    storyLineNameSearchCriteria:string
  ):Observable<StoryLine[]> {

    return this.http
      .get<StoryLine[]>(`http://localhost/server/comics/storylines.php?pageid=${pageId>-1?pageId:""}&seriesid=${(seriesId>-1?seriesId:"")}&issueid=${(issueId>-1?issueId:"")}&storyarcid=${(storyArcId>-1?storyArcId:"")}&storylineid=${(storyLineId>-1?storyLineId:"")}&name=${(storyLineNameSearchCriteria)}`)
      .pipe(map(results=><StoryLine[]>results));
  }  

  public getStoryLinesPromise(
    pageId:number,    
    seriesId:number,
    issueId:number,
    storyLineId:number,
    storyArcId:number,
    storyLineNameSearchCriteria:string
  ) {

    return this.http
      .get(`http://localhost/server/comics/storylines.php?pageid=${pageId>-1?pageId:""}&seriesid=${(seriesId>-1?seriesId:"")}&issueid=${(issueId>-1?issueId:"")}&storyarcid=${(storyArcId>-1?storyArcId:"")}&storylineid=${(storyLineId>-1?storyLineId:"")}&name=${(storyLineNameSearchCriteria === undefined?"":storyLineNameSearchCriteria)}`)
      .toPromise()
      .then(res => <any[]> res)
      .then(data => { return data; });
  }  

  public getStoryArcs(
    pageId:number,    
    seriesId:number,
    issueId:number,
    storyLineId:number,    
    storyArcId:number
  ):Observable<StoryArc[]> {

    return this.http
      .get<StoryArc[]>(`http://localhost/server/comics/storyarcs.php?pageid=${pageId>-1?pageId:""}&seriesid=${(seriesId>-1?seriesId:"")}&issueid=${(issueId>-1?issueId:"")}&storyarcid=${(storyArcId>-1?storyArcId:"")}&storylineid=${(storyLineId>-1?storyLineId:"")}`)
      .pipe(map(results=><StoryArc[]>results));
  }  

  public search(
    seriesId:number, 
    issueId:number, 
    storyArcId:number, 
    storyLineId:number
  ):Observable<SearchResultsRow[]> {
    
    return this.http
    .get<SearchResultsRow[]>(`http://localhost/server/comics/search.php?seriesid=${(seriesId>-1?seriesId:"")}&issueid=${(issueId>-1?issueId:"")}&storyarcid=${(storyArcId>-1?storyArcId:"")}&storylineid=${(storyLineId>-1?storyLineId:"")}`)
    .pipe(map(results=><SearchResultsRow[]>results));
  }  

  // public searchRaw(
  //   seriesId:number, 
  //   issueId:number, 
  //   storyArcId:number, 
  //   storyLineId:number) {
    
  //   return this.http
  //   .get(`http://localhost/server/comics/search.php?seriesid=${(seriesId>-1?seriesId:"")}&issueid=${(issueId>-1?issueId:"")}&storyarcid=${(storyArcId>-1?storyArcId:"")}&storylineid=${(storyLineId>-1?storyLineId:"")}`)
  // }  

}
