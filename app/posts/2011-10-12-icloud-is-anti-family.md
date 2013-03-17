My [spouse](http://twitter.com/beckyjoy) and I share an Apple ID. But we also maintain separate Apple IDs. Paradox.

Why? Because nearly a decade ago, it took us all of fifteen minutes to realize that we were purchasing the same songs multiple times from our separate computers.

That realization—and the subsequent decision to share an Apple ID for purchases—has made each new Apple software upgrade increasingly complex over the years. So I made a chart!

Here are most of Apple's services and how we'd *like* to use them:

 | Service                 | him@me.com    | her@me.com    | Success?     |
 | :-----------            | :------------ | :------------ | :------      |
 | App Store               | [y][x]        |               | Yes          |
 | iTunes Store            | [y][x]        |               | Yes          |
 | Home Sharing            | [y][x]        |               | Yes          |
 | iBooks Store            | [y][x]        |               | Yes          |
 | iBooks Bookmark Syncing | [y]           | [x]           | No           |
 | FaceTime                | [y]           | [x]           | Yes          |
 | Game Center             | [y]           | [x]           | Yes          |
 | Ping                    |               |               | LOL Ping     |
 | iMessage                | [y]           | [x]           | Yes          |
 | iCloud Mail             | [y]           | [x]           | Yes          |
 | iCloud Contacts         | [y]           | [x]           | Yes          |
 | iCloud Calendars        | [y]           | [x]           | Yes          |
 | iCloud Reminders        | [y]           | [x]           | Yes          |
 | iCloud Bookmarks        | [y]           | [x]           | Yes          |
 | iCloud Notes            | [y]           | [x]           | Yes          |
 | iCloud Photo Stream     | [y][x]        |               | No           |
 | iCloud Documents & Data | [y]           | [x]           | Yes          |
 | iCloud Find my Device   | [y]           | [x]           | Yes          |
 | iCloud Backup           | [y]           | [x]           | Yes (5GBx2!) |
 | Find my Friends         | [y]           | [x]           | Yes          |
 | iTunes Match            | [x][y]        |               | No           |

So which services don't quite work for us? That'd be iBooks syncing, Photo Stream, and iTunes Match. To my knowledge, there exist no good workarounds for any of these (but I'd be delighted to be corrected).

## iBooks

The Apple ID used for the iBooks Store is also used to synchronize bookmarks, highlights, and the most recent page you've read of each book.

There's a problem when multiple people use the same ID and are both reading the same book: the current page syncing seriously hampers the app's usability. Here it is, in ordered list form:

1. Person A reads up to page 42
2. Person B opens their iBooks app and now they're on page 42
3. Person B flips back to page 1 and reads to page 70
4. Person A re-enters iBooks and now they're on page 70, so they have to scan back to page 42.
5. Yuck.

There's an easy workaround here: never read the same book at the same time. Seriously, that's what we do. We take turns reading books that are installed on no fewer than four devices in our apartment.

## Photo Stream

If both people share a single iPhoto library and/or an Apple TV, Photo Stream is problematic too. We run iPhoto from my computer under my Mac OS X user account. And since each Mac OS X user account can only be associated with one iCloud account, that means the iPhoto library will only ever receive photos from *my* Apple ID's Photo Stream. (Apple TV can only read one user's Photo Stream as well, but that's hardly as significant an issue.)

That means that if I want my spouse's photos in our join iPhoto library, we have to continue syncing them manually over USB. Lame.

## iTunes match

If both people share an iTunes library, then this seems like the biggest annoyance. iTunes Match subscriptions are tied to both the Apple ID used for purchases (hence the $24.99 annual subscription) as well as the device's configured iCloud account. If the two IDs don't match (no pun intended),then iTunes Match won't be seen as available on the device. That means only the primary user's iOS devices will be able to access iTunes Match.

I don't believe one could even purchase multiple iTunes Match subscriptions to resolve this problem, because iTunes (the desktop client) can only have one logged-in Apple ID at a time. Even if you uploaded the entire library two times (once for each Apple ID), you'd still have to sign out from one and then into the other every time you added a song.

To my knowledge, there won't be a workaround to this unless Apple makes significant changes to the service. Until then, secondary users will be forced to keep syncing music manually with iTunes, and will be unable to access their entire music library when outside their home network.

## Why did it have to be this way?

Something tells me that my wife & I are not the only ones in this camp. Apple has clearly incentivized family members to share an Apple ID (for certain services) for over a decade. But as Apple has ushered in the era of the *very personal* computer with iOS and begun offering more varied online services, the friction experienced by folks sharing an Apple ID has only increased.

If you remain unconvinced that this issue poses a problem, ponder this: each iPhone user is asked to assign an Apple ID for **no fewer than seven** distinct Apple services. Why does my *single-user operating system* require me to enter my Apple ID for its stores, for FaceTime, for Game Center, for Ping, for iMessage, for iCloud, and for Find my Friends? This ID sharing incentive has snowballed into an utterly absurd user experience for everyone.

[Aside: my hope is that these problems have nothing to do with the way contracts were structured with the music majors and the movie studios, as that would mean this would be more difficult for Apple to address in the future without renegotiating those contracts.]

Regardless, it seems like the "right" way to resolve this problem would be for Apple to incentivize each person to claim a single Apple ID for themselves. And the best way to do that would be to enable users to assemble themselves into "families" (of up to, say, five), among whom all paid content would be accessible and all created content (like Photo Stream, or calendars) could be shared.

Here's to hoping they agree.


<div class="me-being-up-to-no-good">
  <script type="text/javascript">
    var convertSemanticGirlsAndBoys = function() {
      $('article td').html(function(i,oldHtml) {
        var newHtml = '';
        newHtml += iconify(oldHtml,'[x]','her');
        newHtml += iconify(oldHtml,'[y]','him');

        return newHtml || oldHtml;
      });
    };

    var iconify = function(source,code,klass) {
      return source.indexOf(code) !== -1 ? '<span class="icon '+klass+'"></span>' : '';
    };


    var stripTrailingPipesFromMarkdownTables = function() {
      $('article td:last-child').each(function(i,el) {
        var text = $(el).text();
        if(text.indexOf('|') !== -1) {
          $(el).text(text.replace('|',''));
        }
        if(text.indexOf('Yes') !== -1 ) {
          $(el).addClass('success');
        }
        if(text.indexOf('No') !== -1 ) {
          $(el).addClass('failure');
        }
      });
    };

    (function($) {
      convertSemanticGirlsAndBoys();
      stripTrailingPipesFromMarkdownTables();
    })(jQuery);
  </script>
  <style type="text/css">
    .success {
      color: #4E9600;
      font-weight: bold;
    }
    .failure {
      color: #A62500;
      font-weight: bold;
    }
    .icon {
      display: inline-block;
      width: 16px;
      height: 16px;
    }
    .her {
      background: url('/img/user_female.png') no-repeat;
    }

    .him {
      background: url('/img/user.png') no-repeat;
    }
  </style>
</div>
