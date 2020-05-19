import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';

import { RequestQueueComponent } from 'src/app/widgets/request-queue/request-queue.component';
import { WebScraperComponent } from 'src/app/widgets/web-scraper/web-scraper.component';
import { TechComponent } from 'src/app/components/tech/tech.component';
import { ResourcesComponent } from 'src/app/components/resources/resources.component';
import { WidgetDashboardComponent } from 'src/app/widgets/widget-dashboard/widget-dashboard.component';

const routes: Routes = [
  // { path: '', redirectTo: '/dashboard', pathMatch: 'full' },
  // { path: 'dashboard', component: DashboardComponent },
  // { path: 'detail/:id', component: HeroDetailComponent },
  // { path: 'heroes', component: HeroesComponent }
  { path: 'requestqueue', component: RequestQueueComponent },
  { path: 'webscraper', component: WebScraperComponent },
  { path: 'tech', component: TechComponent },
  { path: 'resources', component: ResourcesComponent },
  { path: 'widgetdashboard', component: WidgetDashboardComponent }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
