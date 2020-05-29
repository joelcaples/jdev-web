import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';

import { AppRoutingModule } from './shared/modules/app-routing/app-routing.module';
import { AppComponent } from './app.component';
import { HttpClientModule } from '@angular/common/http';
import { NgbModule } from '@ng-bootstrap/ng-bootstrap';
import { TechComponent } from './tech/components/tech.component';
import { ResourcesComponent } from './resources/components/resources.component';
import { ComicsComponent } from './comics/components/comics.component';
import { FormsModule } from '@angular/forms';
import { AgGridModule } from 'ag-grid-angular';
import { NavBarComponent } from './shared/components/nav-bar/nav-bar/nav-bar.component';

import { WidgetDashboardComponent } from './widgets/components/widget-dashboard/widget-dashboard.component';
import { RequestQueueComponent } from './widgets/components/request-queue/request-queue.component';
import { WebScraperComponent } from './widgets/components/web-scraper/web-scraper.component';
import { AutoCompleteDemoComponent } from './widgets/components/autocompletedemo/autocompletedemo.component';

import { MenubarModule } from 'primeng/menubar';
import { AutoCompleteModule } from 'primeng/autocomplete';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { ComicSearchComponent } from './comics/components/comic-search/comic-search.component';


@NgModule({
  declarations: [
    AppComponent,
    RequestQueueComponent,
    WebScraperComponent,
    TechComponent,
    ResourcesComponent,
    WidgetDashboardComponent,
    ComicsComponent,
    NavBarComponent,
    ComicSearchComponent,
    AutoCompleteDemoComponent
  ],
  imports: [
    FormsModule,
    BrowserModule,
    AppRoutingModule,
    HttpClientModule,
    NgbModule,
    AgGridModule.withComponents([]),
    MenubarModule,
    AutoCompleteModule,
    BrowserAnimationsModule
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
