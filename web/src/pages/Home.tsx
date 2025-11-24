import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { Badge } from "@/components/ui/badge"
import { Button } from "@/components/ui/button"
import { MessageSquare, Clock, FileText, CheckCircle, TrendingUp, Star, AlertCircle, Calendar } from "lucide-react"

// Mock data for demonstration
const mockMetrics = {
  totalReviews: 247,
  pendingResponses: 12,
  draftResponses: 8,
  submittedToday: 5,
  averageRating: 4.2,
  responseRate: 85,
}

const mockRecentReviews = [
  {
    id: 1,
    user: "Sarah Johnson",
    rating: 5,
    source: "Google",
    date: "2 hours ago",
    preview: "Excellent service! The team was very professional and...",
    status: "pending",
  },
  {
    id: 2,
    user: "Mike Chen",
    rating: 4,
    source: "Yelp",
    date: "4 hours ago",
    preview: "Good experience overall. The product quality was...",
    status: "draft",
  },
  {
    id: 3,
    user: "Emma Davis",
    rating: 5,
    source: "Facebook",
    date: "6 hours ago",
    preview: "Amazing customer support! They went above and beyond...",
    status: "responded",
  },
]

const mockBusinessSites = [
  { name: "Main Location", pending: 8, drafts: 5, submitted: 3 },
  { name: "Downtown Branch", pending: 4, drafts: 3, submitted: 2 },
  { name: "Online Store", pending: 0, drafts: 0, submitted: 0 },
]

export default function Home() {
  return (
    <div className="space-y-8">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h2 className="text-3xl font-bold text-foreground">Dashboard</h2>
          <p className="text-muted-foreground mt-1">Monitor your review management performance</p>
        </div>
        <Button>
          <Calendar className="w-4 h-4 mr-2" />
          View Reports
        </Button>
      </div>

      {/* Key Metrics */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Total Reviews</CardTitle>
            <MessageSquare className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold text-primary">{mockMetrics.totalReviews}</div>
            <p className="text-xs text-muted-foreground">
              <TrendingUp className="inline w-3 h-3 mr-1" />
              +12% from last month
            </p>
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Pending Responses</CardTitle>
            <Clock className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold text-accent">{mockMetrics.pendingResponses}</div>
            <p className="text-xs text-muted-foreground">
              <AlertCircle className="inline w-3 h-3 mr-1" />
              Requires attention
            </p>
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Draft Responses</CardTitle>
            <FileText className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold text-secondary">{mockMetrics.draftResponses}</div>
            <p className="text-xs text-muted-foreground">Ready to review</p>
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Submitted Today</CardTitle>
            <CheckCircle className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold text-wasabi-600">{mockMetrics.submittedToday}</div>
            <p className="text-xs text-muted-foreground">Great progress!</p>
          </CardContent>
        </Card>
      </div>

      {/* Performance Overview */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <Card>
          <CardHeader>
            <CardTitle>Performance Overview</CardTitle>
            <CardDescription>Your review management statistics</CardDescription>
          </CardHeader>
          <CardContent className="space-y-4">
            <div className="flex items-center justify-between">
              <div className="flex items-center space-x-2">
                <Star className="w-4 h-4 text-yellow-500" />
                <span className="text-sm font-medium">Average Rating</span>
              </div>
              <div className="text-2xl font-bold">{mockMetrics.averageRating}</div>
            </div>
            <div className="flex items-center justify-between">
              <div className="flex items-center space-x-2">
                <CheckCircle className="w-4 h-4 text-green-500" />
                <span className="text-sm font-medium">Response Rate</span>
              </div>
              <div className="text-2xl font-bold">{mockMetrics.responseRate}%</div>
            </div>
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <CardTitle>Business Locations</CardTitle>
            <CardDescription>Review status across your locations</CardDescription>
          </CardHeader>
          <CardContent>
            <div className="space-y-3">
              {mockBusinessSites.map((site, index) => (
                <div key={index} className="flex items-center justify-between p-3 rounded-lg bg-muted/50">
                  <div className="font-medium">{site.name}</div>
                  <div className="flex space-x-2">
                    <Badge variant="outline" className="text-accent border-accent">
                      {site.pending} pending
                    </Badge>
                    <Badge variant="outline" className="text-orange-400 border-orange-400">
                      {site.drafts} drafts
                    </Badge>
                    <Badge variant="outline" className="text-wasabi-600 border-wasabi-600">
                      {site.submitted} done
                    </Badge>
                  </div>
                </div>
              ))}
            </div>
          </CardContent>
        </Card>
      </div>

      {/* Recent Reviews */}
      <Card>
        <CardHeader>
          <CardTitle>Recent Reviews</CardTitle>
          <CardDescription>Latest reviews requiring your attention</CardDescription>
        </CardHeader>
        <CardContent>
          <div className="space-y-4">
            {mockRecentReviews.map((review) => (
              <div key={review.id} className="flex items-start space-x-4 p-4 rounded-lg border border-border">
                <div className="flex-shrink-0">
                  <div className="flex items-center space-x-1">
                    {[...Array(5)].map((_, i) => (
                      <Star
                        key={i}
                        className={`w-4 h-4 ${i < review.rating ? "text-yellow-500 fill-current" : "text-gray-300"}`}
                      />
                    ))}
                  </div>
                </div>
                <div className="flex-1 min-w-0">
                  <div className="flex items-center justify-between">
                    <div className="flex items-center space-x-2">
                      <p className="text-sm font-medium text-foreground">{review.user}</p>
                      <Badge variant="outline" className="text-xs">
                        {review.source}
                      </Badge>
                    </div>
                    <div className="flex items-center space-x-2">
                      <span className="text-xs text-muted-foreground">{review.date}</span>
                      <Badge
                        variant={
                          review.status === "pending"
                            ? "destructive"
                            : review.status === "draft"
                              ? "secondary"
                              : "default"
                        }
                      >
                        {review.status}
                      </Badge>
                    </div>
                  </div>
                  <p className="text-sm text-muted-foreground mt-1">{review.preview}</p>
                </div>
              </div>
            ))}
          </div>
        </CardContent>
      </Card>
    </div>
  )
}
