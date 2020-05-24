import { Component, OnInit, Input, Output, EventEmitter } from '@angular/core';
import { Series } from 'src/app/models/comics.series.model';
import { StoryArc } from 'src/app/models/comics.storyArc.model';
import { Issue } from 'src/app/models/comics.issue.model';
import { AutoCompleteModule } from 'primeng/autocomplete';
import { StoryLine } from 'src/app/models/comics.story-line.model';
import { ComicsService } from 'src/app/services/comics.service';

@Component({
  selector: 'comic-search',
  templateUrl: './comic-search.component.html',
  styleUrls: ['./comic-search.component.scss']
})
export class ComicSearchComponent implements OnInit {

  // @Input()
  // selectedSeries:Series;
  // @Input()
  // selectedIssue:Issue;
  // @Input()
  // selectedStoryArc:StoryArc;

  private storyLineNameSearchCriteria:string;
  public storyLineSearch:StoryLine;

  // @Input() storyLineSearchResult: StoryLine;
  @Output() storyLineFound = new EventEmitter<StoryLine>();
  
  constructor(private comicsService:ComicsService) { }

  ngOnInit(): void {

  }

  filteredStoryLineSingle: StoryLine[];

  filterStoryLineSingle(event) {
      let query = event.query;

        this.comicsService.getStoryLinesPromise(
          // -1, 
          // this.selectedSeries?.seriesId, 
          // this.selectedIssue?.issueId, 
          // -1,
          // this.selectedStoryArc?.storyArcId,
          this.storyLineNameSearchCriteria
        )    
        .then(storyLines => {
          this.filteredStoryLineSingle = this.filterStoryLine(query, storyLines);
          // this.storyLineFound.emit(this.filteredStoryLineSingle[0]);
        });
  }

  filterStoryLine(query, storyLines: any[]):any[] {
      let filtered : any[] = [];
      for(let i = 0; i < storyLines.length; i++) {
          let storyLine = storyLines[i];
          if (storyLine.storyLineName.toLowerCase().indexOf(query.toLowerCase()) == 0) {
              filtered.push(storyLine);
          }
      }
      return filtered;
  }

  storyLineFoundInternal($event) {
    // this.storyLineFound.emit(this.storyLineSearch);
  }
}
