import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';

import { RequestQueueComponent } from 'src/app/widgets/components/request-queue/request-queue.component';
import { WebScraperComponent } from 'src/app/widgets/components/web-scraper/web-scraper.component';
import { TechComponent } from '../../../tech/components/tech.component';
import { ResourcesComponent } from '../../../resources/components/resources.component';
import { WidgetDashboardComponent } from 'src/app/widgets/components/widget-dashboard/widget-dashboard.component';
import { ComicsComponent } from '../../../comics/components/comics.component'
import { AutoCompleteDemoComponent } from 'src/app/widgets/components/autocompletedemo/autocompletedemo.component';

const routes: Routes = [
  // { path: '', redirectTo: '/dashboard', pathMatch: 'full' },
  // { path: 'dashboard', component: DashboardComponent },
  // { path: 'detail/:id', component: HeroDetailComponent },
  // { path: 'heroes', component: HeroesComponent }
  { path: 'requestqueue', component: RequestQueueComponent },
  { path: 'webscraper', component: WebScraperComponent },
  { path: 'autocompletedemo', component: AutoCompleteDemoComponent },
  { path: 'tech', component: TechComponent },
  { path: 'resources', component: ResourcesComponent },
  { path: 'widgetdashboard', component: WidgetDashboardComponent },
  { path: 'comics', component: ComicsComponent }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
