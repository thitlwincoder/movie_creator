abstract class Filter {}

String filterList(List<Filter> filters) {
  return filters.join(',');
}
